
#include <QApplication>
#include <assert.h>
#include <string>
#include <iostream>

#include<appwindow.h>

#include "product.h"
#include "productrepo.h"

void testEntity() {
    Product product = Product(1, std::string("patrunjel"), 7.0);
    assert(1 == product.getId());

    Product* product2 = new Product(2, std::string("kushkush"), 20.0);
    assert("kushkush" == product2->getName());
}

void testRepo() {
    ProductRepo* repo = new ProductRepo("/home/motan/work/cpp/examen-product/f1.txt", "/home/motan/work/cpp/examen-product/f2.txt");
    std::cout << "Repo has: " << repo->getProducts().size() << " products \n";
    assert(repo->getProducts().size() != 0);
}

int main(int argc, char *argv[])
{
    testEntity();
    testRepo();
    QApplication a(argc, argv);
//    MainWindow w;
  //  w.show();
    ProductRepo* repo = new ProductRepo("/home/motan/work/cpp/examen-product/f1.txt", "/home/motan/work/cpp/examen-product/f2.txt");
    ProductCtrl* ctrl = new ProductCtrl(repo);
    AppWindow w(ctrl);
    w.show();

    return a.exec();
}
