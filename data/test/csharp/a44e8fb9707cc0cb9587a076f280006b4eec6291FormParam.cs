using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace fluidedotnet
{
  public delegate void MyCallbackDelegate(SceneParam param);


  public partial class FormParam : Form
  {
    MyCallbackDelegate callback;

    Instrument instrument= new Instrument();

    public FormParam()
    {
      InitializeComponent();
    }
    public void InitParam(string path,MyCallbackDelegate c)
    {
      callback = c;
      var files = from file in Directory.GetFiles(path)
                  orderby file where file.EndsWith(".geo")
                  select file;

      foreach (var file in files)
      {
        FileList.Items.Add(Path.GetFileNameWithoutExtension(file));
      }
      XTrack.Value = 100;
      instrument.zoom = true;
      instrument.zoomx = XTrack.Value;
      instrument.changeinstrument = true;
      SetParams(true);

    }

    private void FormParam_Load(object sender, EventArgs e)
    {

    }

    public void SetParams(bool reinit)
    {
      SceneParam param = new SceneParam();
      param.reinit = reinit;
      if(FileList.SelectedIndex!=-1)
        param.file = FileList.SelectedItem.ToString();
      else
//        param.file = "s2";
//      param.file = "right2";
      param.file = "free2";
      //      param.gx = XTrack.Value;// / 100.0;
      param.instrument = instrument;
      callback(param);
    }
    private void FileList_SelectedIndexChanged(object sender, EventArgs e)
    {
      instrument = new Instrument();
      SetParams(true);
    }
    private void XTrack_Scroll(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.zoom = true;
      instrument.zoomx = XTrack.Value;
      instrument.changeinstrument = true;
      SetParams(false);
    }

    private void ButDrop_Click(object sender, EventArgs e)
    {
      instrument = new  Instrument();
      instrument.changeinstrument = true;
      instrument.drop = true;
      SetParams(false);
    }

    private void butPipe_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.pipe = true;
      SetParams(false);

    }

    private void butObstacle_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.setter = true;
      SetParams(false);

    }

    private void butDelate_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.remover = true;
      SetParams(false);

    }

    private void butForce_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.forceup = true;
      SetParams(false);

    }

    private void butForceDown_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.forcedown = true;
      SetParams(false);

    }

    private void butPush_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.push = true;
      SetParams(false);
    }
    private void button1_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.none = true;
      SetParams(false);

    }

    private void butSave_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.save = true;
      SetParams(false);

    }

    private void buttLift_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.forcelift = true;
      SetParams(false);

    }

    private void buttMove_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.forcemove = true;
      SetParams(false);

    }

    private void butShowNeed_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.showneed = true;
      SetParams(false);

    }

    private void butShowSurf_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.showsurf = true;
      SetParams(false);

    }

    private void btnPause_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.pause = true;
      SetParams(false);

    }

    private void btnStep_Click(object sender, EventArgs e)
    {
      instrument = new Instrument();
      instrument.changeinstrument = true;
      instrument.step = true;
      SetParams(false);

    }

  }
}
