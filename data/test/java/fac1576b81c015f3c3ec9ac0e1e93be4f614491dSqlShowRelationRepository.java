package fengfei.ucm.repository.impl;

import fengfei.ucm.entity.photo.PhotoInfo;
import fengfei.ucm.repository.PhotoRepository;
import fengfei.ucm.repository.ShowRelationRepository;
import fengfei.ucm.repository.UserRepository;

import java.util.List;

public class SqlShowRelationRepository implements ShowRelationRepository {

    UserRepository userRepository = new SqlUserRepository();
    PhotoRepository photoRepository = new SqlPhotoRepository();

    @Override
    public List<PhotoInfo> folllowingPhoto(int idUser, int offset, int row)
        throws Exception {

        return null;
    }

}
