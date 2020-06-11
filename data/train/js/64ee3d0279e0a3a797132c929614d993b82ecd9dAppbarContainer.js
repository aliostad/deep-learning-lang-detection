import {connect} from 'react-redux'
import Appbar from '../components/Appbar'
import {removeAllFile, startUpload, openDrawer, loadPhotos, resetGallery} from '../actions/UploadFileAction'

const mapStateToProps = (state) => {
    return {
        files: state.files,
        uploadedFiles: state.uploadedFiles,
        selectedAlbum: state.selectedAlbum,
        albums: state.albums,
        page: state.page
    }
};

const mapDispatchToProps = (dispatch) => {
    return {
        removeAll: () => {
            dispatch(removeAllFile())
        },
        upload: (files, folder) => {
            dispatch(startUpload(files, folder, dispatch))
        },
        openDrawer: () => {
            dispatch(openDrawer())
        },
        loadPhotos: (album) => {
            loadPhotos(album, dispatch)
        },
        resetGallery: () => {
            dispatch(resetGallery())
        }
    }
};

export default connect(mapStateToProps, mapDispatchToProps)(Appbar)