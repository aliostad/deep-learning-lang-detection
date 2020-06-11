#ifndef INFERNO_PYTHON_EXPORT_MODEL_MAPS_HXX
#define INFERNO_PYTHON_EXPORT_MODEL_MAPS_HXX

// boost
#include <boost/python/def_visitor.hpp>
#include <boost/python/suite/indexing/indexing_suite.hpp>
#include <boost/python/copy_non_const_reference.hpp>
#include <boost/python/return_value_policy.hpp>
#include <boost/mpl/if.hpp>

// vigra numpy array converters
#include <vigra/numpy_array.hxx>
#include <vigra/numpy_array_converters.hxx>

// inferno 
#include "inferno/model/maps/model_maps.hxx"
#include "inferno/model/model_items.hxx"



namespace inferno{
namespace python{

namespace bp = boost::python;

template<class MODEL, class T, class TAG>
struct ModelMapVisitorNumpy1DApi : 
    public bp::def_visitor<ModelMapVisitorNumpy1DApi<MODEL, T, TAG> >
{
    friend class bp::def_visitor_access;

    typedef MODEL Model;
    typedef typename TAG:: template Map<T>::type MapType;

    template <class classT>
    void visit(classT& c) const
    {
        c
            .def(
                "view",
                vigra::registerConverters(&view), 
                RetValPol<CustWardPost<0,1,bp::return_by_value> >()
            )
        ;
    }

    static vigra::NumpyAnyArray
    view(MapType & map){
        T * dataPtr = &map[0];
        const auto numpyType = vigra::NumpyArrayValuetypeTraits<T>::typeCode;
        npy_intp strides[1] = {sizeof(T)};
        vigra::TinyVector<uint64_t, 1> shape( TAG::size(map.model()));

        auto  arrayPythonPtr = vigra::constructNumpyArrayFromData(shape, strides, numpyType, dataPtr);
       
        vigra::NumpyAnyArray array(arrayPythonPtr);
        return array;
    } 
};


template<class MODEL, class T, class TAG>
struct ModelMapVisitorOptionalApi : 
    public bp::def_visitor<ModelMapVisitorOptionalApi<MODEL, T, TAG> >
{
    friend class bp::def_visitor_access;

    typedef MODEL Model;
    typedef typename TAG:: template Map<T>::type MapType;
    typedef ModelMapVisitorNumpy1DApi<MODEL, T, TAG> Numpy1dApi;

    template <class classT>
    void visit(classT& c) const
    {
        c
            .def(Numpy1dApi())
        ;
    }
};


template<class MODEL, class T, class TAG>
struct ModelMapVisitorRequiredApi : 
    public bp::def_visitor<ModelMapVisitorRequiredApi<MODEL, T, TAG> >
{
    friend class bp::def_visitor_access;

    typedef MODEL Model;
    typedef typename TAG:: template Map<T>::type MapType;
    typedef ModelMapVisitorOptionalApi<MODEL, T, TAG> OptionalApi;

    template <class classT>
    void visit(classT& c) const
    {
        c
            .def(bp::init<const Model &>())
            .def(bp::init<const Model &, const T &>())
            .def("assign",&assign)
            .def("assign",&assignWithVal)
            .def("model",&MapType::model, bp::return_internal_reference<>())
            // export the optional api
            .def(OptionalApi())
        ;
    }

    static void assign(MapType & map, const Model & model){
        map.assign(model);
    }
    static void assignWithVal(
        MapType & map, 
        const Model & model,
        const T  & val
    ){
        map.assign(model, val);
    }
};






template< class MODEL>
struct ModelMapExporter{

    typedef MODEL Model;
    typedef ModelMapExporter<Model> Self;

    typedef models::ModelFactorItems<Model> ModelFactors;
    typedef models::ModelUnaryItems<Model> ModelUnaries;
    typedef models::ModelVariableItems<Model> ModelVariables;


    template<class T, class TAG>
    static void exportModelMapT(
        const std::string & modelName,
        const std::string & dtypeName
    ){
        auto clsName = modelName + TAG::name() + std::string("Map_") + dtypeName;

        typedef typename TAG:: template Map<T>::type MapType;
        bp::class_<MapType, boost::noncopyable>(clsName.c_str(),bp::init<>())
            .def(ModelMapVisitorRequiredApi<MODEL, T, TAG>())
        ;

    }


    static void exportModelMaps(const std::string & modelName){

        Self::exportModelMapT<float, ModelVariables>(modelName,"float32");
        Self::exportModelMapT<double, ModelVariables>(modelName,"float64");
        Self::exportModelMapT<uint64_t, ModelVariables>(modelName,"uint64");
        Self::exportModelMapT<uint8_t, ModelVariables>(modelName,"uint8");
        Self::exportModelMapT<int64_t, ModelVariables>(modelName,"int64");
        Self::exportModelMapT<int8_t, ModelVariables>(modelName,"int8");

        Self::exportModelMapT<float, ModelFactors>(modelName,"float32");
        Self::exportModelMapT<double, ModelFactors>(modelName,"float64");
        //Self::exportModelMapT<uint64_t, ModelFactors>(modelName,"uint64");
        //Self::exportModelMapT<uint8_t, ModelFactors>(modelName,"uint8_t");

        //Self::exportModelMapT<float, ModelUnaries>(modelName,"float32");
        //Self::exportModelMapT<double, ModelUnaries>(modelName,"float64");
        //Self::exportModelMapT<uint64_t, ModelUnaries>(modelName,"uint64");
        //Self::exportModelMapT<uint8_t, ModelUnaries>(modelName,"uint8");
        
    }




};



} // end namespace inferno::python
} // end namespace inferno


#endif /* INFERNO_PYTHON_EXPORT_MODEL_MAPS_HXX */
