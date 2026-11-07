from lm_eval.utils import weighted_f1_score


def process_docs(dataset):
    def _norm(doc):
        review = next((v for k, v in doc.items() if k.endswith("_review")), doc.get("review", ""))
        doc["review"] = review
        doc["label"] = 0 if str(doc.get("sentiment", "")).strip().lower() == "positive" else 1
        return doc
    return dataset.map(_norm)


def process_docs(dataset):
    def _norm(doc):
        review = next((v for k, v in doc.items() if k.endswith("_review")), doc.get("review", ""))
        doc["review"] = review
        doc["label"] = 0 if str(doc.get("sentiment", "")).strip().lower() == "positive" else 1
        return doc
    return dataset.map(_norm)
