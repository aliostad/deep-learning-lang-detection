package org.nterlearning.datamodel.catalog.service;

import com.liferay.portal.service.ServiceWrapper;

/**
 * <p>
 * This class is a wrapper for {@link CourseRelatedService}.
 * </p>
 *
 * @author    Brian Wing Shun Chan
 * @see       CourseRelatedService
 * @generated
 */
public class CourseRelatedServiceWrapper implements CourseRelatedService,
    ServiceWrapper<CourseRelatedService> {
    private CourseRelatedService _courseRelatedService;

    public CourseRelatedServiceWrapper(
        CourseRelatedService courseRelatedService) {
        _courseRelatedService = courseRelatedService;
    }

    /**
     * @deprecated Renamed to {@link #getWrappedService}
     */
    public CourseRelatedService getWrappedCourseRelatedService() {
        return _courseRelatedService;
    }

    /**
     * @deprecated Renamed to {@link #setWrappedService}
     */
    public void setWrappedCourseRelatedService(
        CourseRelatedService courseRelatedService) {
        _courseRelatedService = courseRelatedService;
    }

    public CourseRelatedService getWrappedService() {
        return _courseRelatedService;
    }

    public void setWrappedService(CourseRelatedService courseRelatedService) {
        _courseRelatedService = courseRelatedService;
    }
}
