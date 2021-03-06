#Copyright 2017 Vraj Shah, Arun Kumar
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

source("allentropyinfogain.R")
source("svm_JoinOpt_linear.R")
source("svm_JoinAll_linear.R")
source("svm_JoinOpt_radial.R")
source("svm_JoinAll_radial.R")

library(e1071)
options(width=190)

EHtrain = read.csv("EHtrain10re.csv");
EHtest = read.csv("EHtest10re.csv");
EHhold = read.csv("EHhold10re.csv");
EHtrain = EHtrain[,-1]; #get rid of srch_id
EHtest = EHtest[,-1];
EHhold = EHhold[,-1];
EHall = rbind(EHtrain,EHtest,EHhold)
EHtrain$prop_id = factor(EHtrain$prop_id, levels=levels(EHall$prop_id));
EHtrain$prop_country_id = factor(EHtrain$prop_country_id, levels=levels(EHall$prop_country_id));
EHtrain$site_id = factor(EHtrain$site_id, levels=levels(EHall$site_id));
EHtrain$visitor_location_country_id = factor(EHtrain$visitor_location_country_id, levels=levels(EHall$visitor_location_country_id));
EHtrain$srch_destination_id = factor(EHtrain$srch_destination_id, levels=levels(EHall$srch_destination_id));

EHtest$prop_id = factor(EHtest$prop_id, levels=levels(EHall$prop_id));
EHtest$prop_country_id = factor(EHtest$prop_country_id, levels=levels(EHall$prop_country_id));
EHtest$site_id = factor(EHtest$site_id, levels=levels(EHall$site_id));
EHtest$visitor_location_country_id = factor(EHtest$visitor_location_country_id, levels=levels(EHall$visitor_location_country_id));
EHtest$srch_destination_id = factor(EHtest$srch_destination_id, levels=levels(EHall$srch_destination_id));

EHhold$prop_id = factor(EHhold$prop_id, levels=levels(EHall$prop_id));
EHhold$prop_country_id = factor(EHhold$prop_country_id, levels=levels(EHall$prop_country_id));
EHhold$site_id = factor(EHhold$site_id, levels=levels(EHall$site_id));
EHhold$visitor_location_country_id = factor(EHhold$visitor_location_country_id, levels=levels(EHall$visitor_location_country_id));
EHhold$srch_destination_id = factor(EHhold$srch_destination_id, levels=levels(EHall$srch_destination_id));

print("For JoinAll Radial:") 
print("---------------------------------")
JoinAll_radial(EHtrain,EHtest,EHhold)
