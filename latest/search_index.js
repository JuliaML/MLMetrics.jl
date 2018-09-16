var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#MLMetrics.jl\'s-Documentation-1",
    "page": "Home",
    "title": "MLMetrics.jl\'s Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "#Where-to-begin?-1",
    "page": "Home",
    "title": "Where to begin?",
    "category": "section",
    "text": "If this is the first time you consider using MLMetrics for your machine learning related experiments or packages, make sure to check out the \"Getting Started\" section; specifically \"How to …?\", which lists some of most common scenarios and links to the appropriate places that should guide you on how to approach these scenarios using the functionality provided by this or other packages.Pages = [\"gettingstarted.md\"]\nDepth = 2"
},

{
    "location": "#Classification-Metrics-1",
    "page": "Home",
    "title": "Classification Metrics",
    "category": "section",
    "text": ""
},

{
    "location": "#Regression-Metrics-1",
    "page": "Home",
    "title": "Regression Metrics",
    "category": "section",
    "text": ""
},

{
    "location": "#Index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": "Pages = [\"indices.md\"]"
},

{
    "location": "gettingstarted/#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "gettingstarted/#Getting-Started-1",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "section",
    "text": "MLMetrics.jl is the result of a collaborative effort to ...In this section we will provide a condensed overview of the package. In order to keep this overview concise, we will not discuss any background information or theory on the metrics here in detail."
},

{
    "location": "gettingstarted/#Installation-1",
    "page": "Getting Started",
    "title": "Installation",
    "category": "section",
    "text": "To install MLMetrics.jl, start up Julia and type the following code-snipped into the REPL. It makes use of the native Julia package manger.using Pkg\nPkg.add(\"MLMetrics\")"
},

{
    "location": "gettingstarted/#Overview-1",
    "page": "Getting Started",
    "title": "Overview",
    "category": "section",
    "text": ""
},

{
    "location": "gettingstarted/#How-to-...-?-1",
    "page": "Getting Started",
    "title": "How to ... ?",
    "category": "section",
    "text": ""
},

{
    "location": "gettingstarted/#Getting-Help-1",
    "page": "Getting Started",
    "title": "Getting Help",
    "category": "section",
    "text": "To get help on specific functionality you can either look up the information here, or if you prefer you can make use of Julia\'s native doc-system. The following example shows how to get additional information on accuracy within Julia\'s REPL:?accuracyIf you find yourself stuck or have other questions concerning the package you can find us on the julialang slack or the Machine Learning domain on discourse.julialang.orgMachine Learning on JulialangIf you encounter a bug or would like to participate in the further development of this package come find us on Github.JuliaML/MLMetrics.jl"
},

{
    "location": "classification/#",
    "page": "Classification Metrics",
    "title": "Classification Metrics",
    "category": "page",
    "text": ""
},

{
    "location": "classification/#Classification-Metrics-1",
    "page": "Classification Metrics",
    "title": "Classification Metrics",
    "category": "section",
    "text": ""
},

{
    "location": "classification/#Counts-1",
    "page": "Classification Metrics",
    "title": "Counts",
    "category": "section",
    "text": "<div class=\"confusion\">-  actual \n  condition_positive condition_negative\npredicted predicted_positive true_positives false_positives (type_1_errors)\n predicted_negative false_negatives (type_2_errors) true_negatives</div>correctly_classified vs incorrectly_classified"
},

{
    "location": "classification/#Fractions-1",
    "page": "Classification Metrics",
    "title": "Fractions",
    "category": "section",
    "text": "Name Synonyms Description\naccuracy - Fraction of correctly classified observations.\nf_score - Accuracy measure that considers recall and precision.\nf1_score - Harmonic mean of recall and precision.\nprevalence - Fraction of truly positive outcomes in the data.\npositive_predictive_value precision_score Fraction of positive predicted outcomes that are true positives.\nnegative_predictive_value - Fraction of negative predicted outcomes that are true negatives.\ntrue_positive_rate recall, sensitivity Fraction of truly positive outcomes that were predicted as positive.\nfalse_positive_rate - Fraction of truly negative outcomes that are (wrongly) predicted as positive (i.e. false positives).\ntrue_negative_rate specificity Fraction of truly negative outcomes that were predicted as negative.\nfalse_negative_rate - Fraction of truly positive outcomes that are (wrongly) predicted as negative (i.e. false negatives).\nfalse_discovery_rate - Fraction of positive predicted outcomes that are false positives.\nfalse_omission_rate - Fraction of negative predicted outcomes that are false negatives.\npositive_likelihood_ratio - Fraction of true positive rate by false positive rate.\nnegative_likelihood_ratio - Fraction of false negative rate by true negative rate.\ndiagnostic_odds_ratio - Fraction of positive likelihood ratio by negative likelihood ratio."
},

{
    "location": "counts/condition_negative/#",
    "page": "Condition Negative",
    "title": "Condition Negative",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/condition_negative/#MLMetrics.condition_negative",
    "page": "Condition Negative",
    "title": "MLMetrics.condition_negative",
    "category": "function",
    "text": "condition_negative(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount the number of negative outcomes in targets. Which values denote \"negative\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_negative, condition_positive\n\nExamples\n\njulia> condition_negative(0, 1, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> condition_negative([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n2\n\njulia> condition_negative([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 4\n  :b => 4\n  :c => 4\n\n\n\n\n\n"
},

{
    "location": "counts/condition_negative/#Condition-Negative-1",
    "page": "Condition Negative",
    "title": "Condition Negative",
    "category": "section",
    "text": "condition_negative"
},

{
    "location": "counts/condition_positive/#",
    "page": "Condition Positive",
    "title": "Condition Positive",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/condition_positive/#MLMetrics.condition_positive",
    "page": "Condition Positive",
    "title": "MLMetrics.condition_positive",
    "category": "function",
    "text": "condition_positive(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount the number of positive outcomes in targets. Which value denotes \"positive\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_positive, condition_negative, prevalence\n\nExamples\n\njulia> condition_positive(1, 0, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> condition_positive([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n3\n\njulia> condition_positive([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 2\n  :b => 2\n  :c => 2\n\n\n\n\n\n"
},

{
    "location": "counts/condition_positive/#Condition-Positive-1",
    "page": "Condition Positive",
    "title": "Condition Positive",
    "category": "section",
    "text": "condition_positive"
},

{
    "location": "counts/correctly_classified/#",
    "page": "Correctly Classified",
    "title": "Correctly Classified",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/correctly_classified/#MLMetrics.correctly_classified",
    "page": "Correctly Classified",
    "title": "MLMetrics.correctly_classified",
    "category": "function",
    "text": "correctly_classified(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount the number of predicted outcomes in outputs that agree with the expected outcomes in targets under a two-class interpretation. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\nincorrectly_classified, accuracy\n\nExamples\n\njulia> correctly_classified(0, 0, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> correctly_classified([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n3\n\njulia> correctly_classified([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 3\n  :b => 5\n  :c => 4\n\n\n\n\n\n"
},

{
    "location": "counts/correctly_classified/#Correctly-Classified-1",
    "page": "Correctly Classified",
    "title": "Correctly Classified",
    "category": "section",
    "text": "correctly_classified"
},

{
    "location": "counts/false_negatives/#",
    "page": "False Negatives",
    "title": "False Negatives",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/false_negatives/#MLMetrics.false_negatives",
    "page": "False Negatives",
    "title": "MLMetrics.false_negatives",
    "category": "function",
    "text": "false_negatives(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount how many negative predicted outcomes in outputs are actually marked as positive outcomes in targets. These occurrences are also known as type_2_errors. Which value denotes \"positive\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_negative, condition_positive, false_negative_rate\n\nExamples\n\njulia> false_negatives(1, 0, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> false_negatives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n1\n\njulia> false_negatives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 1\n  :b => 0\n  :c => 2\n\n\n\n\n\n"
},

{
    "location": "counts/false_negatives/#False-Negatives-1",
    "page": "False Negatives",
    "title": "False Negatives",
    "category": "section",
    "text": "false_negatives"
},

{
    "location": "counts/false_positives/#",
    "page": "False Positives",
    "title": "False Positives",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/false_positives/#MLMetrics.false_positives",
    "page": "False Positives",
    "title": "MLMetrics.false_positives",
    "category": "function",
    "text": "false_positives(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount how many positive predicted outcomes in outputs are actually marked as negative outcomes in targets. These occurrences are also known as type_1_errors. Which value denotes \"positive\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_positive, condition_negative, false_positive_rate\n\nExamples\n\njulia> false_positives(0, 1, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> false_positives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n1\n\njulia> false_positives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 2\n  :b => 1\n  :c => 0\n\n\n\n\n\n"
},

{
    "location": "counts/false_positives/#False-Positives-1",
    "page": "False Positives",
    "title": "False Positives",
    "category": "section",
    "text": "false_positives"
},

{
    "location": "counts/incorrectly_classified/#",
    "page": "Incorrectly Classified",
    "title": "Incorrectly Classified",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/incorrectly_classified/#MLMetrics.incorrectly_classified",
    "page": "Incorrectly Classified",
    "title": "MLMetrics.incorrectly_classified",
    "category": "function",
    "text": "incorrectly_classified(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount the number of predicted outcomes in outputs that are misclassified according to the expected outcomes in targets under a two-class interpretation. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\ncorrectly_classified, accuracy\n\nExamples\n\njulia> incorrectly_classified(0, 1, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> incorrectly_classified([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n2\n\njulia> incorrectly_classified([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 3\n  :b => 1\n  :c => 2\n\n\n\n\n\n"
},

{
    "location": "counts/incorrectly_classified/#Incorrectly-Classified-1",
    "page": "Incorrectly Classified",
    "title": "Incorrectly Classified",
    "category": "section",
    "text": "incorrectly_classified"
},

{
    "location": "counts/predicted_negative/#",
    "page": "Predicted Negative",
    "title": "Predicted Negative",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/predicted_negative/#MLMetrics.predicted_negative",
    "page": "Predicted Negative",
    "title": "MLMetrics.predicted_negative",
    "category": "function",
    "text": "predicted_negative(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount the number of negative predicted outcomes in outputs. Which values denote \"negative\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_positive, condition_negative\n\nExamples\n\njulia> predicted_negative(1, 0, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> predicted_negative([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n2\n\njulia> predicted_negative([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 3\n  :b => 3\n  :c => 6\n\n\n\n\n\n"
},

{
    "location": "counts/predicted_negative/#Predicted-Negative-1",
    "page": "Predicted Negative",
    "title": "Predicted Negative",
    "category": "section",
    "text": "predicted_negative"
},

{
    "location": "counts/predicted_positive/#",
    "page": "Predicted Positive",
    "title": "Predicted Positive",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/predicted_positive/#MLMetrics.predicted_positive",
    "page": "Predicted Positive",
    "title": "MLMetrics.predicted_positive",
    "category": "function",
    "text": "predicted_positive(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount the number of positive predicted outcomes in outputs. Which value denotes \"positive\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_negative, condition_positive\n\nExamples\n\njulia> predicted_positive(0, 1, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> predicted_positive([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n3\n\njulia> predicted_positive([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 3\n  :b => 3\n  :c => 0\n\n\n\n\n\n"
},

{
    "location": "counts/predicted_positive/#Predicted-Positive-1",
    "page": "Predicted Positive",
    "title": "Predicted Positive",
    "category": "section",
    "text": "predicted_positive"
},

{
    "location": "counts/true_negatives/#",
    "page": "True Negatives",
    "title": "True Negatives",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/true_negatives/#MLMetrics.true_negatives",
    "page": "True Negatives",
    "title": "MLMetrics.true_negatives",
    "category": "function",
    "text": "true_negatives(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount how many negative predicted outcomes in outputs are also marked as negative outcomes in targets. Which value(s) denote \"negative\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_negative, condition_negative, true_negative_rate\n\nExamples\n\njulia> true_negatives(0, 0, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> true_negatives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n1\n\njulia> true_negatives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 2\n  :b => 3\n  :c => 4\n\n\n\n\n\n"
},

{
    "location": "counts/true_negatives/#True-Negatives-1",
    "page": "True Negatives",
    "title": "True Negatives",
    "category": "section",
    "text": "true_negatives"
},

{
    "location": "counts/true_positives/#",
    "page": "True Positives",
    "title": "True Positives",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "counts/true_positives/#MLMetrics.true_positives",
    "page": "True Positives",
    "title": "MLMetrics.true_positives",
    "category": "function",
    "text": "true_positives(targets, outputs, [encoding]) -> Union{Int, Dict}\n\nCount how many positive predicted outcomes in outputs are also marked as positive outcomes in targets. Which value denotes \"positive\" depends on the given (or inferred) encoding. Typically both parameters are arrays of some form, (e.g. vectors or row-vectors), but its also possible to provide a single obseration as \"scalar\" value.\n\nThe return value of the function depends on the number of labels in the given encoding. In case the encoding is binary (i.e. it has exactly 2 labels), a single integer value is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets: Either an array of multiple ground truths mathbfy, or a single ground truth y.\noutputs: Either an array of multiple predicted outputs mathbfhaty, or a single prediction haty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\n\nSee also\n\npredicted_positive, condition_positive, true_positive_rate\n\nExamples\n\njulia> true_positives(1, 1, LabelEnc.ZeroOne()) # single observation\n1\n\njulia> true_positives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations\n2\n\njulia> true_positives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class\nDict{Symbol,Int64} with 3 entries:\n  :a => 1\n  :b => 2\n  :c => 0\n\n\n\n\n\n"
},

{
    "location": "counts/true_positives/#True-Positives-1",
    "page": "True Positives",
    "title": "True Positives",
    "category": "section",
    "text": "true_positives"
},

{
    "location": "fractions/accuracy/#",
    "page": "Accuracy",
    "title": "Accuracy",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/accuracy/#MLMetrics.accuracy",
    "page": "Accuracy",
    "title": "MLMetrics.accuracy",
    "category": "function",
    "text": "accuracy(targets, outputs, [encoding]; [normalize = true]) -> Float64\n\nCompute the fraction of correctly predicted outcomes in outputs according to the given true targets. This is known as the classification accuracy.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\nnormalize::Bool: Optional keyword argument. If true, the function will return the fraction of correctly classified observations in outputs. Otherwise it returns the total number. Defaults to true.\n\nSee also\n\ncorrectly_classified, f_score\n\nExamples\n\njulia> accuracy([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c])\n0.6\n\njulia> accuracy([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], normalize=false)\n3.0\n\njulia> accuracy([1,0,0,1,1], [1,-1,-1,-1,1], LabelEnc.FuzzyBinary())\n0.8\n\n\n\n\n\n"
},

{
    "location": "fractions/accuracy/#Accuracy-1",
    "page": "Accuracy",
    "title": "Accuracy",
    "category": "section",
    "text": "accuracy"
},

{
    "location": "fractions/diagnostic_odds_ratio/#",
    "page": "Diagnostic Odds Ratio",
    "title": "Diagnostic Odds Ratio",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/diagnostic_odds_ratio/#MLMetrics.diagnostic_odds_ratio",
    "page": "Diagnostic Odds Ratio",
    "title": "MLMetrics.diagnostic_odds_ratio",
    "category": "function",
    "text": "diagnostic_odds_ratio(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nCompute the diagnostic odds ratio (DOR) for the given outputs and targets. It is a useful meassure of the effectiveness of a diagnostic test and is defined as positive_likelihood_ratio / negative_likelihood_ratio. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\npositive_likelihood_ratio, negative_likelihood_ratio\n\nExamples\n\njulia> diagnostic_odds_ratio([0,1,1,0,1], [1,0,1,0,1])\n2.0\n\njulia> diagnostic_odds_ratio([-1,1,1,-1,1], [1,-1,1,-1,1])\n2.0\n\njulia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c], LabelEnc.OneVsRest(:b))\n2.0\n\njulia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.0\n  :b => 2.0\n  :c => Inf\n\njulia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c], avgmode=:micro)\n5.999999999999999\n\njulia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c], avgmode=:macro)\n4.142857142857143\n\n\n\n\n\n"
},

{
    "location": "fractions/diagnostic_odds_ratio/#Diagnostic-Odds-Ratio-1",
    "page": "Diagnostic Odds Ratio",
    "title": "Diagnostic Odds Ratio",
    "category": "section",
    "text": "diagnostic_odds_ratio"
},

{
    "location": "fractions/f_score/#",
    "page": "F-Score",
    "title": "F-Score",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/f_score/#MLMetrics.f_score",
    "page": "F-Score",
    "title": "MLMetrics.f_score",
    "category": "function",
    "text": "f_score(targets, outputs, [encoding], [avgmode], [beta = 1]) -> Float64\n\nCompute the F-score for the outputs given the targets. The F-score is a measure for accessing the quality of binary predictor by considering both recall and the precision. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\nbeta::Number: Optional keyword argument. Used to balance the importance of recall vs precision. The default beta = 1 corresponds to the harmonic mean. A value of beta > 1 weighs recall higher than precision, while a value of beta < 1 weighs recall lower than precision.\n\nSee also\n\naccuracy, positive_predictive_value (aka \"precision\"), true_positive_rate (aka \"recall\" or \"sensitivity\")\n\nExamples\n\njulia> recall([1,0,0,1,1], [1,0,0,0,1])\n0.6666666666666666\n\njulia> precision_score([1,0,0,1,1], [1,0,0,0,1])\n1.0\n\njulia> f_score([1,0,0,1,1], [1,0,0,0,1])\n0.8\n\njulia> f_score([1,0,0,1,1], [1,0,0,0,1], beta = 2)\n0.7142857142857143\n\njulia> f_score([1,0,0,1,1], [1,0,0,0,1], beta = 0.5)\n0.9090909090909091\n\njulia> f_score([1,0,0,1,1], [1,-1,-1,-1,1], LabelEnc.FuzzyBinary())\n0.8\n\njulia> f_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.666667\n  :b => 0.0\n  :c => 0.8\n\njulia> f_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.6\n\n\n\n\n\n"
},

{
    "location": "fractions/f_score/#MLMetrics.f1_score",
    "page": "F-Score",
    "title": "MLMetrics.f1_score",
    "category": "function",
    "text": "f1_score(targets, outputs, [encoding], [avgmode])\n\nSame as f_score, but with beta fixed to 1.\n\n\n\n\n\n"
},

{
    "location": "fractions/f_score/#F-Score-1",
    "page": "F-Score",
    "title": "F-Score",
    "category": "section",
    "text": "f_score\nf1_score"
},

{
    "location": "fractions/false_discovery_rate/#",
    "page": "False Discovery Rate",
    "title": "False Discovery Rate",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/false_discovery_rate/#MLMetrics.false_discovery_rate",
    "page": "False Discovery Rate",
    "title": "MLMetrics.false_discovery_rate",
    "category": "function",
    "text": "false_discovery_rate(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of positive predicted outcomes in outputs that are false positives according to the corresponding targets. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\nfalse_positives, predicted_positive, false_omission_rate\n\nExamples\n\njulia> false_discovery_rate([0,1,1,0,1], [1,1,1,0,1])\n0.25\n\njulia> false_discovery_rate([-1,1,1,-1,1], [1,1,1,-1,1])\n0.25\n\njulia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))\n1.0\n\njulia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.0\n  :b => 1.0\n  :c => 0.333333\n\njulia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.4\n\njulia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.4444444444444444\n\n\n\n\n\n"
},

{
    "location": "fractions/false_discovery_rate/#False-Discovery-Rate-1",
    "page": "False Discovery Rate",
    "title": "False Discovery Rate",
    "category": "section",
    "text": "false_discovery_rate"
},

{
    "location": "fractions/false_negative_rate/#",
    "page": "False Negative Rate",
    "title": "False Negative Rate",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/false_negative_rate/#MLMetrics.false_negative_rate",
    "page": "False Negative Rate",
    "title": "MLMetrics.false_negative_rate",
    "category": "function",
    "text": "false_negative_rate(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of truely positive observations that were (wrongly) predicted as negative. What constitutes \"truly positive\" depends on to the corresponding targets and the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\nfalse_negatives, condition_positive\n\nExamples\n\njulia> false_negative_rate([0,1,1,0,1], [1,0,1,0,1])\n0.3333333333333333\n\njulia> false_negative_rate([-1,1,1,-1,1], [1,1,1,-1,1])\n0.0\n\njulia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:a))\n0.5\n\njulia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.5\n  :b => 1.0\n  :c => 0.0\n\njulia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.4\n\njulia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.5\n\n\n\n\n\n"
},

{
    "location": "fractions/false_negative_rate/#False-Negative-Rate-1",
    "page": "False Negative Rate",
    "title": "False Negative Rate",
    "category": "section",
    "text": "false_negative_rate"
},

{
    "location": "fractions/false_omission_rate/#",
    "page": "False Omission Rate",
    "title": "False Omission Rate",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/false_omission_rate/#MLMetrics.false_omission_rate",
    "page": "False Omission Rate",
    "title": "MLMetrics.false_omission_rate",
    "category": "function",
    "text": "false_omission_rate(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of negative predicted outcomes in outputs that are false negatives according to the corresponding targets. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\nfalse_negatives, predicted_negative, false_discovery_rate\n\nExamples\n\njulia> false_omission_rate([0,1,1,0,1], [1,1,1,0,1])\n0.0\n\njulia> false_omission_rate([-1,1,1,-1,1], [1,1,1,-1,1])\n0.0\n\njulia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))\n0.25\n\njulia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.25\n  :b => 0.25\n  :c => 0.0\n\njulia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.2\n\njulia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.16666666666666666\n\n\n\n\n\n"
},

{
    "location": "fractions/false_omission_rate/#False-Omission-Rate-1",
    "page": "False Omission Rate",
    "title": "False Omission Rate",
    "category": "section",
    "text": "false_omission_rate"
},

{
    "location": "fractions/false_positive_rate/#",
    "page": "False Positive Rate",
    "title": "False Positive Rate",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/false_positive_rate/#MLMetrics.false_positive_rate",
    "page": "False Positive Rate",
    "title": "MLMetrics.false_positive_rate",
    "category": "function",
    "text": "false_positive_rate(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of truly negative observations in outputs that were (wrongly) predicted as positives. What constitutes \"truly negative\" depends on to the corresponding targets and the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ntrue_positives, positive_predictive_value (aka \"precision\"), true_negative_rate (aka \"specificity\"), f_score\n\nExamples\n\njulia> false_positive_rate([0,1,1,0,1], [1,1,1,0,1])\n0.5\n\njulia> false_positive_rate([-1,1,1,-1,1], [1,1,1,-1,1])\n0.5\n\njulia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))\n0.25\n\njulia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.0\n  :b => 0.25\n  :c => 0.333333\n\njulia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.2\n\njulia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.19444444444444442\n\n\n\n\n\n"
},

{
    "location": "fractions/false_positive_rate/#False-Positive-Rate-1",
    "page": "False Positive Rate",
    "title": "False Positive Rate",
    "category": "section",
    "text": "false_positive_rate"
},

{
    "location": "fractions/negative_likelihood_ratio/#",
    "page": "Negative Likelihood Ratio",
    "title": "Negative Likelihood Ratio",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/negative_likelihood_ratio/#MLMetrics.negative_likelihood_ratio",
    "page": "Negative Likelihood Ratio",
    "title": "MLMetrics.negative_likelihood_ratio",
    "category": "function",
    "text": "negative_likelihood_ratio(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nCompute the negative likelihood ratio for the given outputs and targets. It is a useful meassure for assessing the quality of a diagnostic test and is defined as (1 - sensitivity) / specificity. This can also be written as false_negative_rate / true_negative_rate. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\nfalse_negative_rate, true_negative_rate (aka \"specificity\"), positive_likelihood_ratio, diagnostic_odds_ratio\n\nExamples\n\njulia> negative_likelihood_ratio([0,1,1,0,1], [1,0,1,0,1])\n0.6666666666666666\n\njulia> negative_likelihood_ratio([-1,1,1,-1,1], [1,-1,1,-1,1])\n0.6666666666666666\n\njulia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:a))\n1.3333333333333333\n\njulia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 1.33333\n  :b => 1.5\n  :c => 0.0\n\njulia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.8571428571428572\n\njulia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.9600000000000002\n\n\n\n\n\n"
},

{
    "location": "fractions/negative_likelihood_ratio/#Negative-Likelihood-Ratio-1",
    "page": "Negative Likelihood Ratio",
    "title": "Negative Likelihood Ratio",
    "category": "section",
    "text": "negative_likelihood_ratio"
},

{
    "location": "fractions/negative_predictive_value/#",
    "page": "Negative Predictive Value",
    "title": "Negative Predictive Value",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/negative_predictive_value/#MLMetrics.negative_predictive_value",
    "page": "Negative Predictive Value",
    "title": "MLMetrics.negative_predictive_value",
    "category": "function",
    "text": "negative_predictive_value(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of negative predicted outcomes in outputs that are true negatives according to the corresponding targets. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ntrue_negatives, predicted_negative\n\nExamples\n\njulia> negative_predictive_value([0,1,1,0,1], [1,1,1,0,1])\n1.0\n\njulia> negative_predictive_value([-1,1,1,-1,1], [1,1,1,-1,1])\n1.0\n\njulia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))\n0.75\n\njulia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.75\n  :b => 0.75\n  :c => 1.0\n\njulia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.8\n\njulia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.8333333333333334\n\n\n\n\n\n"
},

{
    "location": "fractions/negative_predictive_value/#Negative-Predictive-Value-1",
    "page": "Negative Predictive Value",
    "title": "Negative Predictive Value",
    "category": "section",
    "text": "negative_predictive_value"
},

{
    "location": "fractions/positive_likelihood_ratio/#",
    "page": "Positive Likelihood Ratio",
    "title": "Positive Likelihood Ratio",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/positive_likelihood_ratio/#MLMetrics.positive_likelihood_ratio",
    "page": "Positive Likelihood Ratio",
    "title": "MLMetrics.positive_likelihood_ratio",
    "category": "function",
    "text": "positive_likelihood_ratio(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nCompute the positive likelihood ratio for the given outputs and targets. It is a useful meassure for assessing the quality of a diagnostic test and is defined as sensitivity / (1 - specificity). This can also be written as true_positive_rate / false_positive_rate. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ntrue_positive_rate (aka \"recall\" or \"sensitivity\"), false_positive_rate, negative_likelihood_ratio, diagnostic_odds_ratio\n\nExamples\n\njulia> positive_likelihood_ratio([0,1,1,0,1], [1,1,1,0,1])\n2.0\n\njulia> positive_likelihood_ratio([-1,1,1,-1,1], [1,1,1,-1,1])\n2.0\n\njulia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:c))\n3.0\n\njulia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.0\n  :b => 0.0\n  :c => 3.0\n\njulia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n1.3333333333333335\n\njulia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n1.090909090909091\n\n\n\n\n\n"
},

{
    "location": "fractions/positive_likelihood_ratio/#Positive-Likelihood-Ratio-1",
    "page": "Positive Likelihood Ratio",
    "title": "Positive Likelihood Ratio",
    "category": "section",
    "text": "positive_likelihood_ratio"
},

{
    "location": "fractions/positive_predictive_value/#",
    "page": "Positive Predictive Value",
    "title": "Positive Predictive Value",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/positive_predictive_value/#MLMetrics.positive_predictive_value",
    "page": "Positive Predictive Value",
    "title": "MLMetrics.positive_predictive_value",
    "category": "function",
    "text": "positive_predictive_value(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of positive predicted outcomes in outputs that are true positives according to the correspondig targets. This is also known as \"precision\" (alias precision_score). Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ntrue_positives, predicted_positive, true_positive_rate (aka \"recall\" or \"sensitivity\"), f_score\n\nExamples\n\njulia> precision_score([0,1,1,0,1], [1,1,1,0,1])\n0.75\n\njulia> precision_score([-1,1,1,-1,1], [1,1,1,-1,1])\n0.75\n\njulia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:c))\n0.6666666666666666\n\njulia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 1.0\n  :b => 0.0\n  :c => 0.666667\n\njulia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.6\n\njulia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.5555555555555555\n\n\n\n\n\n"
},

{
    "location": "fractions/positive_predictive_value/#Positive-Predictive-Value-1",
    "page": "Positive Predictive Value",
    "title": "Positive Predictive Value",
    "category": "section",
    "text": "positive_predictive_value"
},

{
    "location": "fractions/prevalence/#",
    "page": "Prevalence",
    "title": "Prevalence",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/prevalence/#MLMetrics.prevalence",
    "page": "Prevalence",
    "title": "MLMetrics.prevalence",
    "category": "function",
    "text": "prevalence(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of positive observations in targets. Which value denotes \"positive\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ncondition_positive\n\nExamples\n\njulia> prevalence([0,1,1,0,1], [1,1,1,0,1])\n0.6\n\njulia> prevalence([-1,1,1,-1,1], [1,1,1,-1,1])\n0.6\n\njulia> prevalence([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:c))\n0.4\n\njulia> prevalence([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.4\n  :b => 0.2\n  :c => 0.4\n\njulia> prevalence([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.3333333333333333\n\n\n\n\n\n"
},

{
    "location": "fractions/prevalence/#Prevalence-1",
    "page": "Prevalence",
    "title": "Prevalence",
    "category": "section",
    "text": "prevalence"
},

{
    "location": "fractions/true_negative_rate/#",
    "page": "True Negative Rate",
    "title": "True Negative Rate",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/true_negative_rate/#MLMetrics.true_negative_rate",
    "page": "True Negative Rate",
    "title": "MLMetrics.true_negative_rate",
    "category": "function",
    "text": "true_negative_rate(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of negative predicted outcomes that are true negatives according to the corresponding targets. This is also known as specificity. Which value(s) denote \"positive\" or \"negative\" depends on the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ntrue_negatives, condition_negative, true_positive_rate (aka \"recall\" or \"sensitivity\")\n\nExamples\n\njulia> true_negative_rate([0,1,1,0,1], [1,1,1,0,1])\n0.5\n\njulia> true_negative_rate([-1,1,1,-1,1], [1,1,1,-1,1])\n0.5\n\njulia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))\n0.75\n\njulia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 1.0\n  :b => 0.75\n  :c => 0.666667\n\njulia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.8\n\njulia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.8055555555555555\n\n\n\n\n\n"
},

{
    "location": "fractions/true_negative_rate/#True-Negative-Rate-1",
    "page": "True Negative Rate",
    "title": "True Negative Rate",
    "category": "section",
    "text": "true_negative_rate"
},

{
    "location": "fractions/true_positive_rate/#",
    "page": "True Positive Rate",
    "title": "True Positive Rate",
    "category": "page",
    "text": "DocTestSetup = quote\n    using MLMetrics, MLLabelUtils\nend"
},

{
    "location": "fractions/true_positive_rate/#MLMetrics.true_positive_rate",
    "page": "True Positive Rate",
    "title": "MLMetrics.true_positive_rate",
    "category": "function",
    "text": "true_positive_rate(targets, outputs, [encoding], [avgmode = :none]) -> Union{Float64, Dict}\n\nReturn the fraction of truly positive observations in outputs that were predicted as positives. This is also known as recall or sensitivity. What constitutes \"truly positive\" depends on to the corresponding targets and the given (or inferred) encoding.\n\nIf encoding is omitted, the appropriate MLLabelUtils.LabelEncoding will be inferred from the types and/or values of targets and outputs. Note that omitting the encoding can cause performance penalties, which may include a lack of return-type inference.\n\nThe return value of the function depends on the number of labels in the given encoding and on the specified avgmode. In case an avgmode other than :none is specified, or the encoding is binary (i.e. it has exactly 2 labels), a single number is returned. Otherwise, the function will compute a separate result for each individual label, where that label is treated as \"positive\" and the other labels are treated as \"negative\". These results are then returned as a single dictionary with an entry for each label.\n\nArguments\n\ntargets::AbstractArray: The array of ground truths mathbfy.\noutputs::AbstractArray: The array of predicted outputs mathbfhaty.\nencoding: Optional. Specifies the possible values in targets and outputs and their interpretation (e.g. what constitutes as a positive or negative label, how many labels exist, etc). It can either be an object from the namespace LabelEnc, or a vector of labels.\navgmode: Optional keyword argument. Specifies if and how class-specific results should be aggregated. This is mainly useful if there are more than two classes. Typical values are :none (default), :micro for micro averaging, or :macro for macro averaging. It is also possible to specify avgmode as a type-stable positional argument using an object from the AvgMode namespace.\n\nSee also\n\ntrue_positives, positive_predictive_value (aka \"precision\"), true_negative_rate (aka \"specificity\"), f_score\n\nExamples\n\njulia> recall([0,1,1,0,1,1], [1,0,1,0,1,1])\n0.75\n\njulia> recall([-1,1,1,-1,1], [1,-1,1,-1,1])\n0.6666666666666666\n\njulia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:a))\n0.5\n\njulia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none\nDict{Symbol,Float64} with 3 entries:\n  :a => 0.5\n  :b => 0.0\n  :c => 1.0\n\njulia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)\n0.6\n\njulia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)\n0.5\n\n\n\n\n\n"
},

{
    "location": "fractions/true_positive_rate/#True-Positive-Rate-1",
    "page": "True Positive Rate",
    "title": "True Positive Rate",
    "category": "section",
    "text": "true_positive_rate"
},

{
    "location": "indices/#",
    "page": "Indices",
    "title": "Indices",
    "category": "page",
    "text": ""
},

{
    "location": "indices/#Functions-1",
    "page": "Indices",
    "title": "Functions",
    "category": "section",
    "text": "Order   = [:function]"
},

{
    "location": "indices/#Types-1",
    "page": "Indices",
    "title": "Types",
    "category": "section",
    "text": "Order   = [:type]"
},

{
    "location": "LICENSE/#",
    "page": "LICENSE",
    "title": "LICENSE",
    "category": "page",
    "text": ""
},

{
    "location": "LICENSE/#LICENSE-1",
    "page": "LICENSE",
    "title": "LICENSE",
    "category": "section",
    "text": "using Markdown\nMarkdown.parse_file(joinpath(@__DIR__, \"..\", \"..\", \"LICENSE.md\"))"
},

]}
