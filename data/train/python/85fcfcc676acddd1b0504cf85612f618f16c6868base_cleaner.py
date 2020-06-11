import json


UNKNOWN_STRING = "unk"
UNKNOWN_PROPERTY = "UNK"

class BaseCleaner(object):

    def __init__(
            self,
            data_path,
            broker_labeller_path,
            property_labeller_path):
        self.data_path = data_path
        self.data = self.load_data(data_path)
        self.broker_labeller_path = broker_labeller_path
        self.broker_labeller = \
                self.load_broker_labeller_data(broker_labeller_path)
        self.property_labeller_path = property_labeller_path
        self.property_labeller = \
                self.load_property_labeller_data(property_labeller_path)
        self.required_fields = [
            "bathrooms", "bedrooms", "broker", "latitude", "longitude",
            "photoCount", "price", "propertySize", "propertyType"]

    def load_data(self, path):
        with open(path, "r") as f:
            return json.load(f)

    def load_broker_labeller_data(self, path):
        with open(path, "r") as f:
            return json.load(f)

    def label_broker(self, broker_string):
        if broker_string:
            if broker_string.lower() in self.broker_labeller:
                return self.broker_labeller[broker_string.lower()]
            else:
                return self.broker_labeller[UNKNOWN_STRING]
        else:
            return self.broker_labeller[UNKNOWN_STRING]

    def load_property_labeller_data(self, path):
        with open(path, "r") as f:
            return json.load(f)

    def label_property(self, property_string):
        if property_string:
            if property_string in self.property_labeller:
                return self.property_labeller[property_string]
            else:
                return self.property_labeller[UNKNOWN_PROPERTY]
        else:
            return self.property_labeller[UNKNOWN_PROPERTY]

    def is_valid_entity(self, entity):
        # Validate missing fields
        mandatory_fields = \
            ["bathrooms", "bedrooms", "latitude", "longitude",
             "price", "propertySize"]
        for field in mandatory_fields:
            if entity[field] is None:
                return False
        return True

    def filter_attributes(self, entity):
        new_entity = {}
        for field in self.required_fields:
            new_entity[field] = entity[field]
        return new_entity

    def normalize_attributes(self, entity):
        entity["broker"] = self.label_broker(entity["broker"])

    def normalize_entity(self, field, mini, maxi, entity):
        if maxi is not mini:
            entity[field] = float(entity[field] - mini) / float(maxi - mini)

    def normalize_data(self, cleaned_data):
        """
        Min-max normalization
        """
        normalized_fields = [
            "bathrooms", "bedrooms", "broker", "latitude", "longitude",
            "photoCount", "propertySize", "propertyType"]
        # map: field -> (min, max)
        min_max_map = {}
        for field in normalized_fields:
            mini = min(cleaned_data, key=lambda x: x[field])[field]
            maxi = max(cleaned_data, key=lambda x: x[field])[field]
            min_max_map[field] = (mini, maxi)
        # convert data
        for entity in cleaned_data:
            for field in normalized_fields:
                mini, maxi = min_max_map[field]
                self.normalize_entity(field, mini, maxi, entity)

    def clean_entity(self, entity):
        new_entity = self.filter_attributes(entity)
        return new_entity

    def clean_data(self):
        cleaned_data = \
            [clean_entity(e) for e in self.data if self.is_valid_entity(e)]
        return cleaned_data

