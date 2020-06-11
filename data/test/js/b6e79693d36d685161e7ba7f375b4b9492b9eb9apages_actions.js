import { apiFetchIfNeeded } from './api_actions';
import { fileFetchIfNeeded } from './file_actions';

export function homeAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('portfolio/projects')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('portfolio/projectsImages/?imgType=mni'));
                    }
                );
            }
        );
    };
};

export function projectsAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('portfolio/projects')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('portfolio/projectTags')).then(
                            response => {
                                return dispatch(apiFetchIfNeeded('portfolio/projectsCategories')).then(
                                    response => {
                                        return dispatch(apiFetchIfNeeded('portfolio/projectsImages/?imgType=mni'));
                                    }
                                );
                            }
                        );
                    }
                );
            }
        );
    };
}

export function projectSingleAction(params) {
    let slug = params.slug;
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('portfolio/projects')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('portfolio/projectTags')).then(
                            response => {
                                return dispatch(apiFetchIfNeeded('portfolio/projectsImages?imgType=gal&project__slug=' + slug)).then(
                                    response => {
                                        return dispatch(apiFetchIfNeeded('portfolio/projectsLinks/?project__slug=' + slug));
                                    }
                                );
                            }
                        );
                    }
                );
            }
        );
    };
}

export function aboutAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('about/entry'));
            }
        );
    };
}

export function diaryAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('diary/posts')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('diary/postTags'));
                    }
                );
            }
        );
    };
}

export function cvAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('cv/cv'));
            }
        );
    };
}

export function subscribeAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/'));
    };
}

export function ligojAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('ligoj/link')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('ligoj/linkTags'));
                    }
                );
            }
        );
    };
}

export function podcastAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('podcast/json/podcast')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('podcast/json/podcastTags'));
                    }
                );
            }
        );
    };
}

export function singlePodcastAction(params) {
    let slug = params.slug;
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('podcast/json/podcast')).then(
                    response => {
                        return dispatch(apiFetchIfNeeded('podcast/json/podcastTags')).then(
                            response => {
                                return dispatch(apiFetchIfNeeded('podcast/json/episodes/' + slug));
                            }
                        );
                    }
                );
            }
        );
    };
}

export function nomadAction() {
    return dispatch => {
        return dispatch(apiFetchIfNeeded('web_client/config/1/')).then(
            response => {
                return dispatch(apiFetchIfNeeded('nomad/city/'));
            }
        );
    };
}
