function auc_score(y_true::Array, y_pred::Array)
    r <- rank(y_pred)
    n_pos <- sum(y_true == 1)
    n_neg <- length(y_true) - n_pos
    auc <- (sum(r[y_true == 1]) - n_pos * (n_pos + 1) /2) / (n_pos * n_neg)
    return(auc)
end

function accuracy_score(y_true::Array, y_pred::Array)
    return((y_true == y_pred) / length(y_true))
end

function average_precision_score(y_true::Array, y_pred::Array)
    return(true)
end

function brier_score(y_true::Array, y_pred::Array)
    return(true)
end

function classification_report(y_true::Array, y_pred::Array)
    return(true)
end

function confusion_matrix(y_true::Array, y_pred::Array)
    return(true)
end

function f1_score(y_true::Array, y_pred::Array)
    return(true)
end

function fbeta_score(y_true::Array, y_pred::Array)
    return(true)
end

function hamming_loss(y_true::Array, y_pred::Array)
    return(true)
end

function hinge_loss(y_true::Array, y_pred::Array)
    return(true)
end

function jaccard_similarity_score(y_true::Array, y_pred::Array)
    return(true)
end

function log_loss(y_true::Array, y_pred::Array)
    return(true)
end

function matthews_corrcoef(y_true::Array, y_pred::Array)
    return(true)
end

function precision_recall_curve(y_true::Array, y_pred::Array)
    return(true)
end

function precision_recall_fscore_support(y_true::Array, y_pred::Array)
    return(true)
end

function precision_score(y_true::Array, y_pred::Array)
    return(true)
end

function recall_score(y_true::Array, y_pred::Array)
    return(true)
end

function roc_auc_score(y_true::Array, y_pred::Array)
    return(true)
end

function auc_curve(y_true::Array, y_pred::Array)
    return(true)
end

function (y_true::Array, y_pred::Array)
    return(true)
end

function zero_one_loss(y_true::Array, y_pred::Array)
    return(true)
end
