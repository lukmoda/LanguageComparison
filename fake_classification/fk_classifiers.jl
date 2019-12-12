using CSV
using DataFrames
using MLDataUtils
using DecisionTree
using NaiveBayes
import Statistics: mean

data = CSV.read("data/data_500000s_128f.csv")

train, test = splitobs(shuffleobs(data), at = 0.7)
features = convert(Matrix, dropmissing(train)[:, 1:end-1])
labels = convert(Array, dropmissing(train)[:, end])

#Train RF
time_train = Float32[]
for i = 1:10
    append!(time_train, @elapsed model = build_forest(labels, features))
end
println(mean(time_train))

#Train NaiveBayes
time_train = Float32[]
model = GaussianNB(unique(labels), size(features)[2])
features = convert(Matrix, features')
for i = 1:10
    append!(time_train, @elapsed fit(model, features, labels))
end
println(mean(time_train))

#Predictions (always with 100k datasets)
data = CSV.read("data/data_100000s_128f.csv")
train, test = splitobs(shuffleobs(data), at = 0.7)
features = convert(Matrix, dropmissing(train)[:, 1:end-1])
labels = convert(Array, dropmissing(train)[:, end])

#model = build_forest(labels, features)
model = GaussianNB(unique(labels), size(features)[2])
features = convert(Matrix, features')
fit(model, features, labels)

time_train = Float32[]
obs = convert(Array, test[1:30000, 1:end-1])
obs = Array(obs')
for i = 1:10
    #append!(time_train, @elapsed apply_forest(model, obs))
    append!(time_train, @elapsed NaiveBayes.predict(model, obs))
end
println(mean(time_train))
