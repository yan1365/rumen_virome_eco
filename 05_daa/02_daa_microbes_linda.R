#!/usr/bin/env Rscript

setwd("/fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/R_project")
# Load libraries
library(tidyverse)
library(Maaslin2)
library(LinDA)
library(gtools) 
library(phyloseq)
library(MicrobiomeStat)


# load data
daa_genus_full <- read.csv("full_genus_abundance_animal_performance_linda.csv")
rownames(daa_genus_full) <- daa_genus_full$Genera
daa_genus_full$Genera <- NULL
daa_species_full <- read.csv("full_species_abundance_animal_performance_linda.csv")
rownames(daa_species_full) <- daa_species_full$Species
daa_species_full$Species <- NULL
metadata_performance <- read.csv("metadata_animal_performance.csv")
projects <- unique(metadata_performance$study)

LINDA <- function(project){
  if (project == "PRJNA448333"){
    meta <- metadata_performance %>% filter(study =="PRJNA448333")
    id <- meta$id
    filter_genus <- daa_genus_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.001) > 0.6*length(x), TRUE, FALSE))
    daa_genus_ready <- daa_genus_full[filter_genus, id]
    
    filter_species <- daa_species_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.0001) > 0.6*length(x), TRUE, FALSE))
    daa_species_ready <- daa_species_full[filter_species, id]
    
    
    genus_out <- linda(daa_genus_ready, meta, formula = '~treatment + (1|breed)', 
                       feature.dat.type = 'proportion')$output[[1]]
    
    species_out <- linda(daa_species_ready, meta, formula = '~treatment + (1|breed)', 
                         feature.dat.type = 'proportion')$output[[1]]
    
    treatment <- unique(metadata_performance %>% filter(study =="PRJNA448333") %>% select(treatment)) %>% unlist()
    
    genus_out$treatment1 <- treatment[1]
    genus_out$treatment2 <- treatment[2]
    genus_out$project <- project
    genus_out$note <- NA
    genus_out <- genus_out %>% as.data.frame() %>% rownames_to_column()
    
    species_out$treatment1 <- treatment[1]
    species_out$treatment2 <- treatment[2]
    species_out$project <- project
    species_out$note <- NA
    species_out <- species_out %>% as.data.frame() %>% rownames_to_column()
  }
  
  else if (project == "PRJEB23561")  ## beef and dairy separate
  {
    # beef
    meta_beef = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef")
    id <- meta_beef$id
    
    filter_genus <- daa_genus_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.001) > 0.6*length(x), TRUE, FALSE))
    daa_genus_ready <- daa_genus_full[filter_genus, id]
    
    filter_species <- daa_species_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.0001) > 0.6*length(x), TRUE, FALSE))
    daa_species_ready <- daa_species_full[filter_species, id]
    
    
    genus_out_beef <- linda(daa_genus_ready, meta_beef, formula = '~treatment', 
                            feature.dat.type = 'proportion')$output[[1]]
    
    species_out_beef <- linda(daa_species_ready, meta_beef, formula = '~treatment', 
                              feature.dat.type = 'proportion')$output[[1]]
    
    treatment_beef <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef") %>% select(treatment)) %>% unlist()
    
    
    genus_out_beef$treatment1 <- treatment_beef[1]
    genus_out_beef$treatment2 <- treatment_beef[2]
    genus_out_beef$project <- project
    genus_out_beef$note <- "Beef"
    genus_out_beef <- genus_out_beef %>% as.data.frame() %>% rownames_to_column()
    
    species_out_beef$treatment1 <- treatment_beef[1]
    species_out_beef$treatment2 <- treatment_beef[2]
    species_out_beef$project <- project
    species_out_beef$note <- "Beef"
    species_out_beef <- species_out_beef %>% as.data.frame() %>% rownames_to_column()
    
    
    # repeat for dairy 
    meta_dairy = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy")
    id <- meta_dairy$id
    filter_genus <- daa_genus_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.001) > 0.6*length(x), TRUE, FALSE))
    daa_genus_ready <- daa_genus_full[filter_genus, id]
    
    filter_species <- daa_species_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.0001) > 0.6*length(x), TRUE, FALSE))
    daa_species_ready <- daa_species_full[filter_species, id]
    
    genus_out_dairy <- linda(daa_genus_ready, meta_dairy, formula = '~treatment', 
                             feature.dat.type = 'proportion')$output[[1]]
    
    species_out_dairy <- linda(daa_species_ready, meta_dairy, formula = '~treatment', 
                               feature.dat.type = 'proportion')$output[[1]]
    
    
    treatment_dairy <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy") %>% select(treatment)) %>% unlist()
    
    genus_out_dairy$treatment1 <- treatment_dairy[1]
    genus_out_dairy$treatment2 <- treatment_dairy[2]
    genus_out_dairy$project <- project
    genus_out_dairy$note <- "dairy"
    genus_out_dairy <- genus_out_dairy %>% as.data.frame() %>% rownames_to_column()
    
    species_out_dairy$treatment1 <- treatment_dairy[1]
    species_out_dairy$treatment2 <- treatment_dairy[2]
    species_out_dairy$project <- project
    species_out_dairy$note <- "Dairy"
    species_out_dairy <- species_out_dairy %>% as.data.frame() %>% rownames_to_column()
    
    species_out <- rbind(species_out_beef, species_out_dairy)
    genus_out <- rbind(genus_out_beef, genus_out_dairy)
  }
  
  else if (length(metadata_performance %>% filter(study == project) %>% select(treatment) %>% unique() %>% unlist()) > 2){  # treatment number > 2
    meta = metadata_performance %>% filter(study ==project) 
    id <- meta$id
    filter_genus <- daa_genus_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.001) > 0.6*length(x), TRUE, FALSE))
    daa_genus_ready <- daa_genus_full[filter_genus, id]
    
    filter_species <- daa_species_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.0001) > 0.6*length(x), TRUE, FALSE))
    daa_species_ready <- daa_species_full[filter_species, id]
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    combi <- combinations(3,2,treatment)
    
    species_tmp <- data.frame(matrix(ncol = 12, nrow = 0))
    genus_tmp <- data.frame(matrix(ncol = 12, nrow = 0))
    
    for (f in 1:3){
      trt <- combi[f, ]
      meta = metadata_performance %>% filter(study == project) %>% filter(treatment %in% trt)
      genus_out <- linda(daa_genus_ready, meta, formula = '~treatment', 
                         feature.dat.type = 'proportion')$output[[1]]
      
      species_out <- linda(daa_species_ready, meta, formula = '~treatment', 
                           feature.dat.type = 'proportion')$output[[1]]
      
      
      genus_out$treatment1 <- trt[1]
      genus_out$treatment2 <-  trt[2]
      genus_out$project <- project
      genus_out$note <- NA
      genus_out <- genus_out %>% rownames_to_column()
      
      species_out$treatment1 <-  trt[1]
      species_out$treatment2 <-  trt[2]
      species_out$project <- project
      species_out$note <- NA
      species_out <- species_out %>% rownames_to_column()
      
      species_tmp <- rbind(species_tmp, species_out)
      genus_tmp <-rbind(genus_tmp, genus_out)
      
    }
    species_out <- species_tmp
    genus_out <- genus_tmp
  }
  
  else {
    meta = metadata_performance %>% filter(study == project)
    id <- meta$id
    
    filter_genus <- daa_genus_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.001) > 0.6*length(x), TRUE, FALSE))
    daa_genus_ready <- daa_genus_full[filter_genus, id]
    
    filter_species <- daa_species_full[,id] %>% apply(1, function(x) ifelse(sum(x > 0.0001) > 0.6*length(x), TRUE, FALSE))
    daa_species_ready <- daa_species_full[filter_species, id]
    
    
    genus_out <- linda(daa_genus_ready, meta, formula = '~treatment', 
                       feature.dat.type = 'proportion')$output[[1]]
    
    species_out <- linda(daa_species_ready, meta, formula = '~treatment', 
                         feature.dat.type = 'proportion')$output[[1]]
    
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    
    genus_out$treatment1 <- treatment[1]
    genus_out$treatment2 <- treatment[2]
    genus_out$project <- project
    genus_out$note <- NA
    genus_out <- genus_out %>% as.data.frame() %>% rownames_to_column()
    
    
    species_out$treatment1 <- treatment[1]
    species_out$treatment2 <- treatment[2]
    species_out$project <- project
    species_out$note <- NA
    species_out <- species_out %>% as.data.frame() %>% rownames_to_column()
    
  }
  return(list(genus_df = genus_out, species_df = species_out))
}

linda_species_out <- data.frame()
linda_genus_out <- data.frame()

for (f in projects){
  print(f)
  tmp <- LINDA(f)
  linda_genus_out <- rbind(linda_genus_out, tmp$genus_df)
  linda_species_out <- rbind(linda_species_out, tmp$species_df)
  
}

write_csv(linda_genus_out, "linda_genus_out.csv")
write_csv(linda_species_out, "linda_species_out.csv")

