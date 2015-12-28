library(dplyr)

# get feature name
feature_name_map <- read.table("./UCI HAR Dataset/features.txt") %>% rename(feature_name=V2)
basic_feature_index <- grep("-mean|-std", feature_name_map$feature_name)
# get activity name
act_name_map <- read.table("./UCI HAR Dataset/activity_labels.txt") %>% rename(act_class=V1) %>% rename(activity=V2)

# train data first
train_act <- read.table("./UCI HAR Dataset/train/y_train.txt") %>% rename(act_class=V1)
train_act2 <- select(merge(train_act, act_name_map), activity)

train_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt") %>% rename(subject = V1)

train_feature_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_basic_feature_data <- select(train_feature_data, basic_feature_index)
names(train_basic_feature_data) <- feature_name_map$feature_name[basic_feature_index]

train_data = cbind(train_act2,train_sub,train_basic_feature_data)

# now test data
test_act <- read.table("./UCI HAR Dataset/test/y_test.txt") %>% rename(act_class=V1)
test_act2 <- select(merge(test_act, act_name_map), activity)

test_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt") %>% rename(subject = V1)

test_feature_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_basic_feature_data <- select(test_feature_data, basic_feature_index)
names(test_basic_feature_data) <- feature_name_map$feature_name[basic_feature_index]

test_data = cbind(test_act2,test_sub,test_basic_feature_data)

# now merge
all_data <- rbind(train_data,test_data)

# now create an independent dataset
summary_data <- aggregate( all_data[,3:length(names(all_data))], 
                                    all_data[,c("subject","activity")], mean )
write.table(summary_data, file = "output.txt", row.names = FALSE)
