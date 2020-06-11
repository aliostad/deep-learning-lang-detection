using System;
using System.Drawing;
using System.Collections;
using System.Windows.Forms;

namespace musicTherapy1
{
    public partial class Legend : Form
    {
        public MainForm parentForm;
        public Legend()
        {
            InitializeComponent();
        }
      //  ListView instrumentListView;

        private void Legend_Load(object sender, EventArgs e)
        {
          // instrumentListView = new ListView();
            //instrumentListView.
            instrumentListView.LargeImageList = new ImageList();
            instrumentListView.LargeImageList.ImageSize = new Size(32, 32);
            instrumentListView.SmallImageList = new ImageList();
            instrumentListView.SmallImageList.ImageSize = new Size(16, 16);
            
            instrumentListView.View = View.List;
            
            instrumentListView.Columns.Add("Name", 120, HorizontalAlignment.Left);
            instrumentListView.Columns.Add("Category", 120, HorizontalAlignment.Left);
            instrumentListView.Columns.Add("Sub-category", 120, HorizontalAlignment.Left);
            instrumentListView.Columns.Add("Description", 120, HorizontalAlignment.Right);
          
            ArrayList instCategList;
            instCategList = ((MainForm)(this.parentForm)).instrumentCategorylist;
            int numOfCategories = instCategList.Count;
            int imageIndexCounter = 0;
            for (int CategoryCount = 0; CategoryCount < instCategList.Count; CategoryCount++)
            {
                Category category = (Category)instCategList[CategoryCount];
           
                if (category.SubCategoryList.Count == 0)
                {
                    ArrayList imageList = (ArrayList)category.ImageList;
                    for (int imageCounter = 0; imageCounter < imageList.Count; imageCounter++)
                    {
                        myImage my_image = (myImage)imageList[imageCounter];
                        Bitmap image = new Bitmap(my_image.instrumentImage,new Size(32,32));
                        instrumentListView.LargeImageList.Images.Add( image);
                        ListViewItem instrumentListItem = instrumentListView.Items.Add(my_image.instrumentName, imageIndexCounter);
                        image = new Bitmap(my_image.instrumentImage, new Size(16, 16));
                        instrumentListView.SmallImageList.Images.Add(image);
                     
                        instrumentListItem.SubItems.Add(my_image.instrumentInfo.Category);
                        instrumentListItem.SubItems.Add(my_image.instrumentInfo.SubCategory);
                        instrumentListItem.SubItems.Add(((MainForm)(this.parentForm)).getInstrumentInfo(my_image.instrumentInfo.Category,"",my_image.instrumentInfo.Name)); //my_image.instrumentInfo.SubCategory);
                        imageIndexCounter++;

                  
                    }
                  
                }
                else //has a sub catagory
                {
                    ArrayList subCategoryList = (ArrayList)category.SubCategoryList;

                    for (int subCategoryCounter = 0; subCategoryCounter < subCategoryList.Count; subCategoryCounter++)
                    {
                        SubCategory subCategory = (SubCategory)subCategoryList[subCategoryCounter];
                   
                        ArrayList imageList = (ArrayList)subCategory.ImageList;
                        for (int imageCounter = 0; imageCounter < imageList.Count; imageCounter++)
                        {
                            myImage my_image = (myImage)imageList[imageCounter];
                            Bitmap  image = new Bitmap( my_image.instrumentImage,new Size(32,32));
                            instrumentListView.LargeImageList.Images.Add(my_image.instrumentImage);
                            image = new Bitmap(my_image.instrumentImage, new Size(16, 16));
                            instrumentListView.SmallImageList.Images.Add(image);

                            ListViewItem instrumentListItem = instrumentListView.Items.Add(my_image.instrumentName, imageIndexCounter);
                            instrumentListItem.SubItems.Add(my_image.instrumentInfo.Category);
                            instrumentListItem.SubItems.Add(my_image.instrumentInfo.SubCategory);
                            instrumentListItem.SubItems.Add(my_image.instrumentInfo.Description);
                            imageIndexCounter++;


//                    

                        }//for
                       
                    }//for of sub catefories
                 
                }//has has sub category
             
            }
            //counterOfPictureLines++;
         
        }

        private void LargIcons_Click(object sender, EventArgs e)
        {
            instrumentListView.View = View.Details;
           // instrumentListView.Refresh();
            //instrumentListView.Invalidate();
        }

        private void ViewList_Click(object sender, EventArgs e)
        {
            instrumentListView.View = View.List;
        }

        private void LargeIcons_Click(object sender, EventArgs e)
        {
            instrumentListView.View = View.LargeIcon;
        }

        private void SmallIcons_Click(object sender, EventArgs e)
        {
            instrumentListView.View = View.SmallIcon;
        }

    }
}