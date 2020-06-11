using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;

namespace StoryboardDemo
{
    public class ModelInterfaceViewModel : ModelElementViewModel
    {
        private ObservableCollection<ModelInstrumentViewModel> mChildren = new ObservableCollection<ModelInstrumentViewModel>();
        private ModelInstrumentViewModel mSelectedInstrument;


        public ModelInterfaceViewModel(ModelInterface model)
            : base(model)
        { }

        public ObservableCollection<ModelInstrumentViewModel> Children
        {
            get { return mChildren; }
        }
        public ModelInstrumentViewModel SelectedInstrument
        {
            get { return mSelectedInstrument; }
            set
            {
                mSelectedInstrument = value;
                OnPropertyChanged("SelectedInstrument");
            }
        }
    }
}
