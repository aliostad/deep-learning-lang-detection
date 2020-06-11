#include "../include/plugins/samplePlugin.hpp"
#include "../include/plugins/sampleEffect.hpp"

using namespace std;

SamplePlugin::SamplePlugin() {
  name = "Sample plugin";
}

Gtk::Widget* SamplePlugin::getWidget() {
  box = new Gtk::Box();
  checkbox = new Gtk::CheckButton("Vertical");
  box->pack_start(*checkbox, false, false);
  return box;
}

Effect* SamplePlugin::getEffect() {
  if(checkbox == NULL)
    return new SampleEffect(SampleEffect::NOOPERATION);
  if(checkbox->get_active())
    return new SampleEffect(SampleEffect::VERTICAL);
  else
    return new SampleEffect(SampleEffect::HORIZONTAL);
}

string SamplePlugin::getName() {
  return name;
}
