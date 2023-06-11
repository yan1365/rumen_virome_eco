#!/usr/bin/env Rscript
 
setwd("/fs/ess/PAS0439/MING/virome_ecology/results/R_project/virome_microbes_network_RUG4941/")

library(tidyverse)
library(SpiecEasi)

virome = read_csv("virome_prevalence_filtered_70.csv")
microbe = read_csv("microbes_prevalence_filtered_70.csv")

se.rvd <- spiec.easi(list(as.matrix(virome[,2:ncol(virome)]), as.matrix(microbe[,2:ncol(microbe)])), method='mb', nlambda=100, 
              lambda.min.ratio=1e-3, pulsar.params = list(thresh = 0.01, ncores=20, rep.num=999))


# total edges
edges = sum(getRefit(se.rvd))/2
#tuning lambda.min.ratio and nlambda until stability close to 0.05

sta = getStability(se.rvd)

saveRDS(se.rvd, file = "se.rvd.rds")
