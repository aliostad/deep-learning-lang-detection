<?php

class katalogController extends controller {
  public function index() {
    $buku = new buku;
    $data = $buku->fetchAll();

    $this->view->title = 'Katalog';
    $this->view->data = $data;

    $this->view->show('head');
    $this->view->show('sidebar');
    $this->view->show('header');
    $this->view->show('navbar');
    $this->view->show('katalogSide');
    $this->view->show('katalog');
    $this->view->show('footer');

  }

  public function filter($kategori) {
    $buku = new buku;

    $data = $buku->fetchAll($kategori);
    $title = empty($kategori) ? 'Katalog' : $kategori;

    $this->view->title = $title;
    $this->view->data = $data;

    $this->view->show('head');
    $this->view->show('sidebar');
    $this->view->show('header');
    $this->view->show('navbar');
    $this->view->show('katalogSide');
    $this->view->show('katalog');
    $this->view->show('footer');

  }

  public function detail($ISBN) {
    $buku = new buku;

    $data = $buku->fetch($ISBN);
    $title = empty($kategori) ? 'Katalog' : $data['judul'];

    $this->view->title = $title;
    $this->view->data = $data;

    $this->view->show('head');
    $this->view->show('sidebar');
    $this->view->show('header');
    $this->view->show('navbar');
    $this->view->show('katalogSide');
    $this->view->show('detail');
    $this->view->show('footer');

  }
}

?>
