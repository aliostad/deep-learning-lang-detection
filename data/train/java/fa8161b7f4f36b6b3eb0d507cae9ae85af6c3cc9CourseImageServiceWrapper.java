package org.nterlearning.datamodel.catalog.service;

import com.liferay.portal.service.ServiceWrapper;

/**
 * <p>
 * This class is a wrapper for {@link CourseImageService}.
 * </p>
 *
 * @author    Brian Wing Shun Chan
 * @see       CourseImageService
 * @generated
 */
public class CourseImageServiceWrapper implements CourseImageService,
    ServiceWrapper<CourseImageService> {
    private CourseImageService _courseImageService;

    public CourseImageServiceWrapper(CourseImageService courseImageService) {
        _courseImageService = courseImageService;
    }

    /**
     * @deprecated Renamed to {@link #getWrappedService}
     */
    public CourseImageService getWrappedCourseImageService() {
        return _courseImageService;
    }

    /**
     * @deprecated Renamed to {@link #setWrappedService}
     */
    public void setWrappedCourseImageService(
        CourseImageService courseImageService) {
        _courseImageService = courseImageService;
    }

    public CourseImageService getWrappedService() {
        return _courseImageService;
    }

    public void setWrappedService(CourseImageService courseImageService) {
        _courseImageService = courseImageService;
    }
}
