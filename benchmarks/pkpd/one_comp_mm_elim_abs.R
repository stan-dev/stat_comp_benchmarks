library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

setwd('/Users/Betancourt/Documents/Research/Presentations/2017.01.20 NYC PK:PD Course/exercises/2 - one_comp_mm_elim_abs')

c_light <- c("#DCBCBC")
c_light_highlight <- c("#C79999")
c_mid <- c("#B97C7C")
c_mid_highlight <- c("#A25050")
c_dark <- c("#8F2727")
c_dark_highlight <- c("#7C0000")

# Simulate data
sim <- stan(file='sim_one_comp_mm_elim_abs.stan', iter=1,
            chains=1, seed=194838, algorithm="Fixed_param")

t0 = extract(sim)$t_init[1]
C0 = array(extract(sim)$C_init[1,], dim = 1)
D = extract(sim)$D[1]
V = extract(sim)$V[1]
times = extract(sim)$ts[1,]
N_t = length(extract(sim)$ts[1,])
C_hat = extract(sim)$C_hat[1,]

stan_rdump(c("t0", "C0", "D", "V", "times", "N_t", "C_hat"), file="one_comp_mm_elim_abs.data.R")

# Fit data using ODEs
input_data <- read_rdump("one_comp_mm_elim_abs.data.R")

fit <- stan(file='one_comp_mm_elim_abs.stan', data=input_data,
            iter=2000, chains=2, seed=4938483)

print(fit)

params = extract(fit)

par(mfrow=c(2, 2))

hist(params$k_a, main="", xlab="k_a (1/day)", col=c_dark, border=c_dark_highlight)
abline(v=0.75,col=c_light,lty=1, lwd=3)

hist(params$K_m, main="", xlab="K_m (mg/L)", col=c_dark, border=c_dark_highlight)
abline(v=0.25, col=c_light, lty=1, lwd=3)

hist(params$V_m, main="", xlab="V_m (1/day)", col=c_dark, border=c_dark_highlight)
abline(v=1, col=c_light, lty=1, lwd=3)

hist(params$sigma, main="", xlab="sigma (mg/L)", col=c_dark, border=c_dark_highlight)
abline(v=0.1,col=c_light,lty=1, lwd=3)

cred <- sapply(1:length(input_data$times), function(x) quantile(params$C[,x,1], probs = c(0.05, 0.5, 0.95)))
plot(input_data$times, input_data$C_hat, xlab="t (days)",
ylab="Concentration (mg/L)", ylim=c(0, 16), col=1, pch=16, cex=0.8)
polygon(c(input_data$times, rev(input_data$times)), c(cred[1,], rev(cred[3,])),
col = c_mid, border = NA)
lines(input_data$times, cred[2,], col=c_dark, lwd=2)
points(input_data$times, input_data$C_hat, col=1, pch=16, cex=0.8)

cred <- sapply(1:length(input_data$times), function(x) quantile(params$C_ppc[,x], probs = c(0.05, 0.5, 0.95)))
plot(input_data$times, input_data$C_hat, xlab="t (days)",
ylab="Concentration (mg/L)", ylim=c(0, 16), col=1, pch=16, cex=0.8)
polygon(c(input_data$times, rev(input_data$times)), c(cred[1,], rev(cred[3,])),
col = c_mid, border = NA)
lines(input_data$times, cred[2,], col=c_dark, lwd=2)
points(input_data$times, input_data$C_hat, col=1, pch=16, cex=0.8)
