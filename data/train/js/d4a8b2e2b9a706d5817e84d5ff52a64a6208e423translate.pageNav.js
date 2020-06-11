function translate_pageNav() {
    rename('.page-nav .nextpager-info', 'text', dict.pageNav_info);
    rename('.page-nav .nextpager-btn-prev', 'text', dict.pageNav_prev);
    rename('.page-nav .nextpager-btn-next', 'text', dict.pageNav_next);
    document.querySelector('.page-nav .nextpager-btn-prev').style.width = 'auto';
    document.querySelector('.page-nav .nextpager-btn-prev').style.marginRight = '20px';
    document.querySelector('.page-nav .nextpager-btn-next').style.width = 'auto';
    document.querySelector('.page-nav .nextpager-btn-next').style.marginRight = '20px';
}

