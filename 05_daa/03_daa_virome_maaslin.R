#!/usr/bin/env Rscript

setwd("/fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/R_project")
# Load libraries
library(tidyverse)
library(Maaslin2)
library(LinDA)
library(gtools) 
library(data.table)


# Load data
virome <- fread("for_beta_diversity_performance.csv")
metadata_performance <- read_csv("metadata_animal_performance.csv")
projects <- unique(metadata_performance$study)

# Maaslin2
maaslin <- function(project){
  
  if (project == "PRJNA448333"){
    maasline_meta = metadata_performance %>% filter(study =="PRJNA448333")
    virome_out <- Maaslin2(input_data = virome, input_metadata = maasline_meta, 
                          output = "maaslin2_tmp", fixed_effects = "treatment" , random_effects = "breed" ,
                          normalization = "TSS", min_prevalence = 0.5, cores = 8)$results
    
    treatment <- unique(metadata_performance %>% filter(study =="PRJNA448333") %>% select(treatment)) %>% unlist()
    
    virome_out$treatment1 <- treatment[1]
    virome_out$treatment2 <- treatment[2]
    virome_out$project <- project
    virome_out$note <- NA
    
  }
  
  else if (project == "PRJEB23561")  ## beef and dairy separate
  {
    # beef
    maasline_meta_beef = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef")
    virome_out_beef <- Maaslin2(input_data = virome, input_metadata = maasline_meta_beef, 
                                output = "maaslin2_tmp", fixed_effects = "treatment",
                                normalization = "TSS", min_prevalence = 0.5, cores = 8)$results
    
    
    
    treatment_beef <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef") %>% select(treatment)) %>% unlist()
    
    virome_out_beef$treatment1 <- treatment_beef[1]
    virome_out_beef$treatment2 <- treatment_beef[2]
    virome_out_beef$project <- project
    virome_out_beef$note <- "Beef"
    
    
    # repeat for dairy 
    maasline_meta_dairy = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy")
    virome_out_dairy <- Maaslin2(input_data = virome, input_metadata = maasline_meta_dairy, 
                                output = "maaslin2_tmp", fixed_effects = "treatment",
                                normalization = "TSS", min_prevalence = 0.5, cores = 8)$results
    
    treatment_dairy <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy") %>% select(treatment)) %>% unlist()
    
    virome_out_dairy$treatment1 <- treatment_dairy[1]
    virome_out_dairy$treatment2 <- treatment_dairy[2]
    virome_out_dairy$project <- project
    virome_out_dairy$note <- "Dairy"

    virome_out <- rbind(virome_out_dairy, virome_out_beef)
  }
  
  else if (length(metadata_performance %>% filter(study == project) %>% select(treatment) %>% unique() %>% unlist()) > 2){  # treatment number > 2
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    combi <- combinations(3,2,treatment)
    
    virome_tmp <- data.frame(matrix(ncol = 14, nrow = 0))
    
    for (f in 1:3){
      trt <- combi[f, ]
      maasline_meta = metadata_performance %>% filter(study == project) %>% filter(treatment %in% trt)
      virome_out <- Maaslin2(input_data = virome, input_metadata = maasline_meta, 
                             output = "maaslin2_tmp", fixed_effects = "treatment",
                             normalization = "TSS", min_prevalence = 0.5, cores = 8)$results
      
    
      virome_out$treatment1 <- trt[1]
      virome_out$treatment2 <-  trt[2]
      virome_out$project <- project
      virome_out$note <- NA
      
      virome_tmp <-rbind(virome_tmp, virome_out)
      
    }
    virome_out <- virome_tmp
  }
  
  else {
    maasline_meta = metadata_performance %>% filter(study == project)
    virome_out <- Maaslin2(input_data = virome, input_metadata = maasline_meta, 
                          output = "maaslin2_tmp", fixed_effects = "treatment",
                          normalization = "TSS", min_prevalence = 0.5, cores = 8)$results
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    
    virome_out$treatment1 <- treatment[1]
    virome_out$treatment2 <- treatment[2]
    virome_out$project <- project
    virome_out$note <- NA
    
  }
  return(virome_out)
}

maaslin_virome_out <- data.frame()

for (f in projects){
  print(f)
  tmp <- maaslin(f)
  maaslin_virome_out <- rbind(maaslin_virome_out, tmp)
  
}

write_csv(maaslin_virome_out, "maaslin_virome_out.csv")

