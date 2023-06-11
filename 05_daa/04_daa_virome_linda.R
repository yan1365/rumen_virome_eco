#!/usr/bin/env Rscript

setwd("/fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/R_project")
# Load libraries
library(tidyverse)
library(Maaslin2)
library(LinDA)
library(gtools) 
library(phyloseq)
library(MicrobiomeStat)
library(data.table)


# load data
virome <- fread("for_beta_diversity_performance.csv")
colnames_virome <- virome$id
columns_remove <- c("animal", "trait", "id", "treatment", "study", "liter", "breed")
virome[,(columns_remove):=NULL]
virome <- virome %>% apply(1, function(x) x/sum(x)) # change to proportion
colnames(virome) <- colnames_virome
metadata_performance <- read_csv("metadata_animal_performance.csv")
projects <- unique(metadata_performance$study)

# Linda
LINDA <- function(project){
  if (project == "PRJNA448333"){
    meta <- metadata_performance %>% filter(study =="PRJNA448333")
    virome_out <- linda(virome, meta, formula = '~treatment + (1|breed)', 
                        feature.dat.type = 'proportion', prev.filter = 0.5)$output[[1]]
    
    
    treatment <- unique(metadata_performance %>% filter(study =="PRJNA448333") %>% select(treatment)) %>% unlist()
    
    virome_out$treatment1 <- treatment[1]
    virome_out$treatment2 <- treatment[2]
    virome_out$project <- project
    virome_out$note <- NA
    virome_out <- virome_out %>% rownames_to_column()
    
  }
  
  else if (project == "PRJEB23561")  ## beef and dairy separate
  {
    # beef
    meta_beef = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef")
    
    virome_out_beef <- linda(virome, meta_beef, formula = '~treatment', 
                             feature.dat.type = 'proportion', prev.filter = 0.5)$output[[1]]
    
    treatment_beef <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef") %>% select(treatment)) %>% unlist()
    
    
    virome_out_beef$treatment1 <- treatment_beef[1]
    virome_out_beef$treatment2 <- treatment_beef[2]
    virome_out_beef$project <- project
    virome_out_beef$note <- "Beef"
    virome_out_beef <- virome_out_beef %>% rownames_to_column()
    
    
    # repeat for dairy 
    meta_dairy = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy")
    
    virome_out_dairy <- linda(virome, meta_dairy, formula = '~treatment', 
                              feature.dat.type = 'proportion', prev.filter = 0.5)$output[[1]]
    
    treatment_dairy <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy") %>% select(treatment)) %>% unlist()
    
    virome_out_dairy$treatment1 <- treatment_dairy[1]
    virome_out_dairy$treatment2 <- treatment_dairy[2]
    virome_out_dairy$project <- project
    virome_out_dairy$note <- "dairy"
    virome_out_dairy <- virome_out_dairy %>% rownames_to_column()
    
    virome_out <- rbind(virome_out_beef, virome_out_dairy)
  }
  
  else if (length(metadata_performance %>% filter(study == project) %>% select(treatment) %>% unique() %>% unlist()) > 2){  # treatment number > 2
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    combi <- combinations(3,2,treatment)
    
    virome_tmp <- data.frame(matrix(ncol = 12, nrow = 0))
    
    for (f in 1:3){
      trt <- combi[f, ]
      meta = metadata_performance %>% filter(study == project) %>% filter(treatment %in% trt)
      virome_out <- linda(virome, meta, formula = '~treatment', 
                          feature.dat.type = 'proportion', prev.filter = 0.5)$output[[1]]
      
      
      virome_out$treatment1 <- trt[1]
      virome_out$treatment2 <-  trt[2]
      virome_out$project <- project
      virome_out$note <- NA
      virome_out <- virome_out %>% rownames_to_column()
      
      virome_tmp <- rbind(virome_tmp, virome_out)
      
    }
    virome_out <- virome_tmp
  }
  
  else {
    meta = metadata_performance %>% filter(study == project)
    
    virome_out <- linda(virome, meta, formula = '~treatment', 
                        feature.dat.type = 'proportion', prev.filter = 0.5)$output[[1]]
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    
    virome_out$treatment1 <- treatment[1]
    virome_out$treatment2 <- treatment[2]
    virome_out$project <- project
    virome_out$note <- NA
    virome_out <- virome_out %>% rownames_to_column()
    
  }
  return(virome_out)
}

linda_virome_out <- data.frame()

for (f in projects){
  print(f)
  tmp <- LINDA(f)
  linda_virome_out <- rbind(linda_virome_out, tmp)
  
}

write_csv(linda_virome_out, "linda_virome_out.csv")