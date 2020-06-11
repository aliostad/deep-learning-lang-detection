#include <iostream>
#include <vector>
#include <memory>
#include <mutex>
#include <type_traits>
#include <unordered_map>
using namespace std;
template<typename FuncType, typename ... ArgsType>
auto LoadModel(FuncType func, const ArgsType& ...args)->decltype(func(args...))
{
  cout << sizeof...(args) << endl;
  return func(args...);
}

int func1(const string& info)
{
  cout<<"func1  "<<info<<endl;
  return 0;
}

//template<typename MAP_TYPE, typename LOCK_TYPE, typename MODEL_TYPE>
//void UpdateModelMap(uint64_t key, MODEL_TYPE& model, LOCK_TYPE& lock, MAP_TYPE& model_map)
//{
//  write_lock(&lock);
//  model_map[key] = model;
//}

struct CtrModel
{
  int32_t expid;
  string model_tag;
};

template<typename T>
void test(T v)
{
  shared_ptr<T> list(new T());
}

class ModelManager
{
  public:
    ModelManager() = default;

    template<typename MAP_TYPE, typename LOCK_TYPE, typename MODEL_TYPE>
    void UpdateModel(int32_t expid, MODEL_TYPE& model,  LOCK_TYPE& lock, MAP_TYPE& model_type);

    template<typename MAP_TYPE, typename LOCK_TYPE, typename MODEL_TYPE>
    bool GetModel(int32_t expid, MODEL_TYPE& model, LOCK_TYPE& lock, MAP_TYPE& models);

    template<typename MODEL_TYPE>
    bool Get(const string& type, int32_t expid, MODEL_TYPE& model);

    void LoadModel(const string& type, int32_t expid, const string& modeltag);

    template<typename MODEL_TYPE>
    void LoadFromFile(const MODEL_TYPE& model);

  private:
    std::mutex ctr_lock_;
    unordered_map<int32_t, CtrModel> ctr_models_;
};

void ModelManager::LoadModel(const string& type, int32_t expid, const string& modeltag)
{
  if (type == "ctr")
  {
    CtrModel ctr_model = {expid, modeltag};
    UpdateModel(expid, ctr_model, ctr_lock_, ctr_models_);
  }
}

template<typename MODEL_TYPE>
bool ModelManager::Get(const string& type, int32_t expid, MODEL_TYPE& model)
{
  if (type == "ctr")
  {
    return GetModel(expid, model, ctr_lock_, ctr_models_);
  }
  return false;
}

template<typename MAP_TYPE, typename LOCK_TYPE, typename MODEL_TYPE>
bool ModelManager::GetModel(int32_t expid, MODEL_TYPE& model, LOCK_TYPE& lock, MAP_TYPE& models)
{
  std::lock_guard<std::mutex> guard(lock);
  auto it = models.find(expid);
  if (it != models.end())
  {
    model = it->second;
    return true;
  }
  return false;
}

template<typename MAP_TYPE, typename LOCK_TYPE, typename MODEL_TYPE>
void ModelManager::UpdateModel(int32_t expid, MODEL_TYPE& model, LOCK_TYPE& lock, MAP_TYPE& models)
{
  std::lock_guard<std::mutex> guard(lock);
  models[expid] = model;
}

template<typename MODEL_TYPE>
void ModelManager::LoadFromFile(const MODEL_TYPE& model_tag)
{
  if (is_same<MODEL_TYPE, CtrModel>::value)
  {
    cout<<"is same"<<endl;
  }
  MODEL_TYPE model;
}

int main()
{
  string name = "songjw";
  LoadModel(func1, name);

  string str = "songjw";
  test(str);

  ModelManager model_manager;
  model_manager.LoadModel("ctr", 100, "hello_world");

  CtrModel ctr_model;
  if (model_manager.Get("ctr", 100, ctr_model))
  {
    cout<<ctr_model.model_tag<<endl;
  }

  model_manager.LoadFromFile(ctr_model);

  if (is_same<CtrModel, CtrModel>::value)
  {
    cout<<"is same"<<endl;
  }
  return 0;
}
