library(MRInstruments)
library(plyr)
library(dplyr)  
library(data.table)
library(TwoSampleMR)
library(ggplot2)

expo_rt <- fread()
expo_rt <- format_data(expo_rt,
                       type = 'exposure',
                       snp_col = "rsID",
                       beta_col = "beta",
                       se_col = "SE",
                       pval_col = "P.weightedSumZ",
                       effect_allele_col = "eff.allele",
                       other_allele_col = "ref.allele")

expo_rt<- expo_rt[expo_rt$pval.exposure < 1e-5,]
expo_rt <- clump_data(expo_rt,clump_kb = 10000,clump_r2 = 0.001)



outc_rt<- format_data(out_dat,
                      type="outcome",
                      snps = expo_rt$SNP,
                      snp_col = "variant_id",
                      beta_col = "frequentist_add_beta_1",
                      se_col = "frequentist_add_se_1",
                      eaf_col = "RAF",
                      pval_col = "p_value",
                      effect_allele_col = "alleleA",
                      other_allele_col = "alleleB")



harm_rt <- harmonise_data(exposure_dat =  expo_rt,outcome_dat = outc_rt,action=1)
mr_result<- mr(harm_rt)


dat <- harmonise_data(exposure_dat = geneData,outcome_dat = out_data)
mr_result <- mr(dat = dat)



het <- mr_heterogeneity(harm_rt)

run_mr_presso(dat,NbDistribution = 1000)

ple <- mr_pleiotropy_test(harm_rt)

singlesnp_res<- mr_singlesnp(harm_rt)

singlesnpOR=generate_odds_ratios(singlesnp_res)

sen_res<- mr_leaveoneout(harm_rt)

p1 <- mr_scatter_plot(mr_result, harm_rt)
p1[[1]]

p2 <- mr_forest_plot(singlesnp_res)
p2[[1]]

p3 <- mr_leaveoneout_plot(sen_res)
p3[[1]]

res_single <- mr_singlesnp(harm_rt)
p4 <- mr_funnel_plot(singlesnp_res)
p4[[1]]




library(BWMR)
library(ggplot2)

library(data.table)


path_res <- ('')


ExampleData <- fread(paste0(path_res,'/******.txt')) #harmonise data


fit.BWMR <- BWMR(gammahat = ExampleData$beta.exposure,
                 Gammahat = ExampleData$beta.outcome,
                 sigmaX = ExampleData$se.exposure,
                 sigmaY = ExampleData$se.outcome) 

pdf(paste0(path_res,'/BWMR1.pdf'),height = 8,width = 9)
fit.BWMR$plot1
dev.off()

pdf(paste0(path_res,'/BWMR2.pdf'),height = 8,width = 9)
fit.BWMR$plot2
dev.off()

pdf(paste0(path_res,'/BWMR3.pdf'),height = 8,width = 9)
fit.BWMR$plot3
dev.off()

pdf(paste0(path_res,'/BWMR4.pdf'),height = 8,width = 9)
fit.BWMR$plot4
dev.off()


fit.BWMR