## ----ModelFitting-----------------------------------------------------------------------------------

# Linear regression for temperature effect
lm.model_temp <- lm(Stays ~ temperature_2m_mean_c, data = d.merged_data)
summary(lm.model_temp)

# Linear regression for snowfall effect
lm.model_snow <- lm(Stays ~ snowfall_sum_cm, data = d.merged_data)
summary(lm.model_snow)

# Linear regression for temperature effect
lm.model_temp <- lm(Stays ~ rain_sum_mm, data = d.merged_data)
summary(lm.model_temp)