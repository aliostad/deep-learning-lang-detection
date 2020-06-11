#include "PersonService.h"

PersonService::PersonService() {
    pRepo = PersonRepository();
}

bool PersonService::add(Person p) {
    return pRepo.add(p);
}

vector<Person> PersonService::getSortedPersons(string order) {
    return pRepo.getSortedPersons(order);
}

bool PersonService::save() {
    return pRepo.save();
}

bool PersonService::erase(vector<Person> results, string answer) {
    return pRepo.erase(results, answer);
}

vector<Person> PersonService::search(string input, string word) {
    return pRepo.search(input, word);
}


double PersonService::getSize() {
    return pRepo.getSize();
}
