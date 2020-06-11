#include "productctrl.h"
#include <algorithm>

ProductCtrl::ProductCtrl(ProductRepo* repo): repo(repo) { }


std::vector<Product> ProductCtrl::getAll() {
    return repo->getProducts();
}


std::vector<Product> ProductCtrl::getSorted() {
    std::vector<Product> out = repo->getProducts();

    std::function<int(Product, Product)> cmp;

    cmp = [](Product a, Product b)->bool{return a.getName() < b.getName();};

    std::sort(out.begin(), out.end(), cmp);

    return out;
}

std::vector<long> ProductCtrl::getQtys() {
    std::vector<long> out;
    std::vector<Product> all = repo->getProducts();
    for (Product& p : all) {
        out.push_back(p.getQty());
    }
    return out;
}
