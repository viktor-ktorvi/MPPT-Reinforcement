function [accuracy, prediction, ground_truth] = classification_accuracy(model, X, labels, range)
    out = model.forward_pass(X(:, range));
    
    [~, prediction] = max(out, [], 1);
    [~, ground_truth] = max(labels(:, range), [], 1);
    
    accuracy = sum(prediction == ground_truth) / length(range);
end

