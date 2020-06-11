"use strict"

var happens = require("happens");

module.exports = function(items, opts)
{
  var api = {};
  api.pages = [];
  api.pageIndex = 0;
  api.data = items;
  api.currentPageIndex = 0
  api.currentPage = undefined
  api.options = {
    itemsPerPage: 1,
    loop: false
  };

  happens(api);

  if(opts)
  {
    if(opts.itemsPerPage)
      api.options.itemsPerPage = opts.itemsPerPage

    if(opts.loop != undefined)
      api.options.loop = opts.loop
  }

  api.hasNext = function()
  {
    return (api.currentPageIndex < api.pages.length - 1)
  }

  api.hasPrev = function()
  {
    return (api.currentPageIndex > 0)
  }

  api.createPages = function()
  {
    var dataLength = api.data.length;
    var count = 0;
    api.pages[api.pageIndex] = [];

    for(var i = 0; i < dataLength; i++)
    {
      if(i > 0)
      {
        count++;

        if(count % api.options.itemsPerPage == 0)
        {
          count = 0;
          api.pageIndex++
          api.pages[api.pageIndex] = []
        }
      }

      api.pages[api.pageIndex].push(api.data[i]);
    }

    api.totalPages = api.pages.length;
  }

  api.next = function()
  {
    api.currentPageIndex++
    api.checkNextPrev()
    api.emit("change", api.pages[api.currentPageIndex], api.currentPageIndex);
    api.emit("next", api.pages[api.currentPageIndex], api.currentPageIndex);
  }

  api.prev = function()
  {
    api.currentPageIndex--
    api.checkNextPrev()
    api.emit("change", api.pages[api.currentPageIndex], api.currentPageIndex);
    api.emit("prev", api.pages[api.currentPageIndex], api.currentPageIndex);
  }

  api.checkNextPrev = function()
  {
    if(api.currentPageIndex > api.pages.length - 1)
    {
      if(api.options.loop)
      {
        api.currentPageIndex = 0;
      }
      else
      {
        api.currentPageIndex = api.pages.length - 1;
        api.emit("last:next");
      }
    }

    if(api.currentPageIndex < 0)
    {
      if(api.options.loop)
      {
        api.currentPageIndex = api.pages.length - 1;
      }
      else
      {
        api.currentPageIndex = 0;
        api.emit("last:prev");
      }
    }
  }

  api.go = function(at)
  {
    api.currentPageIndex = at;
    api.checkNextPrev()
    api.emit("change", api.pages[api.currentPageIndex], api.currentPageIndex);
    api.emit("go", api.pages[api.currentPageIndex], api.currentPageIndex);
  }

  api.createPages();

  return api;
}
