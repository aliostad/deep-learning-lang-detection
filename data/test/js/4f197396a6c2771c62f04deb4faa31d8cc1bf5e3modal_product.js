 var loadingHTML;

function showProduct(productID)
  {

     $('#modal_showProduct').html(loadingHTML)
     $('#modal_showProduct').modal('show');
    
    $.ajax({
      type: 'GET',
      url: '/modal/product?productID='+productID+'&action1=show',
      success: function(data){
        $('#modal_showProduct').html(data);
       
      },
      dataType: 'HTML'
    });      
  
  }
  
function initShowProduct()
{
     $('.showProduct').unbind('click');
    $('.showProduct').click(function()
    {
      showProduct($(this).data('productid'));
    });
  }
$(document).ready(function() {

  loadingHTML = $('#modal_showProduct').html();
  initShowProduct();
  
});