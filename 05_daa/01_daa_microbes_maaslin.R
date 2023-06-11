#!/usr/bin/env Rscript

setwd("/fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/R_project")
# Load libraries
library(tidyverse)
library(Maaslin2)
library(LinDA)
library(gtools) 


# Load data
daa_genus <- read_csv("core_genus_abundance_animal_performance.csv")
daa_species <- read_csv("core_species_abundance_animal_performance.csv")
daa_genus_full <- read_csv("full_genus_abundance_animal_performance.csv")
daa_species_full <- read_csv("full_species_abundance_animal_performance.csv")
metadata_performance <- read_csv("metadata_animal_performance.csv")
projects <- unique(metadata_performance$study)

# Maaslin2
maaslin <- function(project){
  
  if (project == "PRJNA448333"){
    maasline_meta = metadata_performance %>% filter(study =="PRJNA448333")
    genus_out <- Maaslin2(input_data = daa_genus_full, input_metadata = maasline_meta, 
                          output = "maaslin2_tmp", fixed_effects = "treatment" , random_effects = "breed" ,
                          normalization = "None", min_prevalence = 0.6, min_abundance = 0.001, cores = 8)$results
    
    species_out <- Maaslin2(input_data = daa_species_full, input_metadata = maasline_meta, 
                            output = "maaslin2_tmp", fixed_effects = "treatment" , random_effects = "breed" ,
                            normalization = "None", min_prevalence = 0.6, min_abundance = 0.0001, cores = 8)$results
    
    treatment <- unique(metadata_performance %>% filter(study =="PRJNA448333") %>% select(treatment)) %>% unlist()
    
    genus_df <- genus_out %>% select("feature", "pval", "qval", "coef")
    genus_df$treatment1 <- treatment[1]
    genus_df$treatment2 <- treatment[2]
    genus_df$project <- project
    genus_df$note <- NA
    
    species_df <- species_out %>% select("feature", "pval", "qval", "coef")
    species_df$treatment1 <- treatment[1]
    species_df$treatment2 <- treatment[2]
    species_df$project <- project
    species_df$note <- NA
    
  }
  
  else if (project == "PRJEB23561")  ## beef and dairy separate
  {
    # beef
    maasline_meta_beef = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef")
    genus_out_beef <- Maaslin2(input_data = daa_genus_full, input_metadata = maasline_meta_beef, 
                               output = "maaslin2_tmp", fixed_effects = "treatment",
                               normalization = "None", min_prevalence = 0.6, min_abundance = 0.001, cores = 8)$results
    
    species_out_beef <- Maaslin2(input_data = daa_species_full, input_metadata = maasline_meta_beef, 
                                 output = "maaslin2_tmp", fixed_effects = "treatment" ,
                                 normalization = "None", min_prevalence = 0.6, min_abundance = 0.0001, cores = 8)$results
    
    treatment_beef <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Beef") %>% select(treatment)) %>% unlist()
    
    genus_df_beef <- genus_out_beef %>% select("feature", "pval", "qval", "coef")
    genus_df_beef$treatment1 <- treatment_beef[1]
    genus_df_beef$treatment2 <- treatment_beef[2]
    genus_df_beef$project <- project
    genus_df_beef$note <- "Beef"
    
    species_df_beef <- species_out_beef %>% select("feature", "pval", "qval", "coef")
    species_df_beef$treatment1 <- treatment_beef[1]
    species_df_beef$treatment2 <- treatment_beef[2]
    species_df_beef$project <- project
    species_df_beef$note <- "Beef"
    
    
    # repeat for dairy 
    maasline_meta_dairy = metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy")
    genus_out_dairy <- Maaslin2(input_data = daa_genus_full, input_metadata = maasline_meta_dairy, 
                                output = "maaslin2_tmp", fixed_effects = "treatment" ,
                                normalization = "None", min_prevalence = 0.6, min_abundance = 0.001, cores = 8)$results
    
    species_out_dairy <- Maaslin2(input_data = daa_species_full, input_metadata = maasline_meta_dairy, 
                                  output = "maaslin2_tmp", fixed_effects = "treatment" ,
                                  normalization = "None", min_prevalence = 0.6, min_abundance = 0.0001, cores = 8)$results
    
    treatment_dairy <- unique(metadata_performance %>% filter(study =="PRJEB23561") %>% filter(animal == "Dairy") %>% select(treatment)) %>% unlist()
    
    genus_df_dairy <- genus_out_dairy %>% select("feature", "pval", "qval", "coef")
    genus_df_dairy$treatment1 <- treatment_dairy[1]
    genus_df_dairy$treatment2 <- treatment_dairy[2]
    genus_df_dairy$project <- project
    genus_df_dairy$note <- "Dairy"
    
    species_df_dairy <- species_out_dairy %>% select("feature", "pval", "qval", "coef")
    species_df_dairy$treatment1 <- treatment_dairy[1]
    species_df_dairy$treatment2 <- treatment_dairy[2]
    species_df_dairy$project <- project
    species_df_dairy$note <- "Dairy"
    
    
    species_df <- rbind(species_df_beef, species_df_dairy)
    genus_df <- rbind(genus_df_beef, genus_df_dairy)
  }
  
  else if (length(metadata_performance %>% filter(study == project) %>% select(treatment) %>% unique() %>% unlist()) > 2){  # treatment number > 2
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    combi <- combinations(3,2,treatment)
    
    species_tmp <- data.frame(matrix(ncol = 8, nrow = 0))
    genus_tmp <- data.frame(matrix(ncol = 8, nrow = 0))
    
    for (f in 1:3){
      trt <- combi[f, ]
      maasline_meta = metadata_performance %>% filter(study == project) %>% filter(treatment %in% trt)
      genus_out <- Maaslin2(input_data = daa_genus_full, input_metadata = maasline_meta, 
                            output = "maaslin2_tmp", fixed_effects = "treatment" ,
                            normalization = "None", min_prevalence = 0.6, min_abundance = 0.001, cores = 8)$results
      
      species_out <- Maaslin2(input_data = daa_species_full, input_metadata = maasline_meta, 
                              output = "maaslin2_tmp", fixed_effects = "treatment" ,
                              normalization = "None", min_prevalence = 0.6, min_abundance = 0.0001, cores = 8)$results
      
      genus_df <- genus_out %>% select("feature", "pval", "qval", "coef")
      genus_df$treatment1 <- trt[1]
      genus_df$treatment2 <-  trt[2]
      genus_df$project <- project
      genus_df$note <- NA
      
      species_df <- species_out %>% select("feature", "pval", "qval", "coef")
      species_df$treatment1 <-  trt[1]
      species_df$treatment2 <-  trt[2]
      species_df$project <- project
      species_df$note <- NA
      
      species_tmp <- rbind(species_tmp, species_df)
      genus_tmp <-rbind(genus_tmp, genus_df)
      
    }
    species_df <- species_tmp
    genus_df <- genus_tmp
  }
  
  else {
    maasline_meta = metadata_performance %>% filter(study == project)
    genus_out <- Maaslin2(input_data = daa_genus_full, input_metadata = maasline_meta, 
                          output = "maaslin2_tmp", fixed_effects = "treatment",
                          normalization = "None", min_prevalence = 0.6, min_abundance = 0.001, cores = 8)$results
    
    species_out <- Maaslin2(input_data = daa_species_full, input_metadata = maasline_meta, 
                            output = "maaslin2_tmp", fixed_effects = "treatment",
                            normalization = "None", min_prevalence = 0.6, min_abundance = 0.0001, cores = 8)$results
    
    treatment <- unique(metadata_performance %>% filter(study == project) %>% select(treatment)) %>% unlist()
    
    genus_df <- genus_out %>% select("feature", "pval", "qval", "coef")
    genus_df$treatment1 <- treatment[1]
    genus_df$treatment2 <- treatment[2]
    genus_df$project <- project
    genus_df$note <- NA
    
    species_df <- species_out %>% select("feature", "pval", "qval", "coef")
    species_df$treatment1 <- treatment[1]
    species_df$treatment2 <- treatment[2]
    species_df$project <- project
    species_df$note <- NA
    
  }
  return(list(genus_df = genus_df, species_df = species_df))
}

maaslin_species_out <- data.frame()
maaslin_genus_out <- data.frame()

for (f in projects){
  print(f)
  tmp <- maaslin(f)
  maaslin_genus_out <- rbind(maaslin_genus_out, tmp$genus_df)
  maaslin_species_out <- rbind(maaslin_species_out, tmp$species_df)
  
}

write_csv(maaslin_genus_out, "maaslin_genus_out.csv")
write_csv(maaslin_species_out, "maaslin_species_out.csv")

