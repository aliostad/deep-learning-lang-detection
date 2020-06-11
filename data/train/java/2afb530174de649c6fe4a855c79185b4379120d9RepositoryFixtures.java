package com.jbrunton.pockettimeline.fixtures;

import com.google.common.collect.FluentIterable;
import com.jbrunton.pockettimeline.api.repositories.TimelineEventsRepository;
import com.jbrunton.pockettimeline.entities.data.ReadableRepository;
import com.jbrunton.pockettimeline.entities.data.SearchableRepository;
import com.jbrunton.pockettimeline.entities.models.Event;
import com.jbrunton.pockettimeline.entities.models.Resource;
import com.jbrunton.pockettimeline.entities.models.Timeline;

import java.util.List;

import rx.Observable;

import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.when;

public class RepositoryFixtures {
    private RepositoryFixtures() {
        // should never be instantiated
    }

    public static class FakeReadableRepositoryDsl<T extends Resource> {
        private final ReadableRepository<T> repository;

        public FakeReadableRepositoryDsl(ReadableRepository<T> repository) {
            this.repository = repository;
        }

        public void toReturn(List<T> resources) {
            when(repository.all()).thenReturn(Observable.just(resources));
            when(repository.find(anyString())).thenAnswer(invocation -> {
                String id = (String) invocation.getArguments()[0];
                T resource = FluentIterable.from(resources)
                        .firstMatch(x -> x.getId().equals(id))
                        .get();
                return Observable.just(resource);
            });
        }

        public void toErrorWith(Throwable error) {
            when(repository.all()).thenReturn(Observable.error(error));
        }
    }

    public static class ReadableRepositoryFindDsl<T extends Resource> {
        private final ReadableRepository<T> repository;
        private final String id;

        public ReadableRepositoryFindDsl(ReadableRepository<T> repository, String id) {
            this.repository = repository;
            this.id = id;
        }

        public void toReturn(T resource) {
            when(repository.find(id)).thenReturn(Observable.just(resource));
        }

        public void toErrorWith(Throwable throwable) {
            when(repository.find(id)).thenReturn(Observable.error(throwable));
        }
    }

    public static class SearchableRepositoryDsl<T extends Resource> {
        private final SearchableRepository<T> repository;
        private final String query;

        public SearchableRepositoryDsl(SearchableRepository<T> repository, String query) {
            this.repository = repository;
            this.query = query;
        }

        public void toReturn(List<T> resources) {
            when(repository.search(query)).thenReturn(Observable.just(resources));
        }

        public void toErrorWith(Throwable throwable) {
            when(repository.search(query)).thenReturn(Observable.error(throwable));
        }
    }

    public static <T extends Resource> FakeReadableRepositoryDsl<T> stub(ReadableRepository<T> repository) {
        return new FakeReadableRepositoryDsl<>(repository);
    }

    public static <T extends Resource> ReadableRepositoryFindDsl<T> stubFind(ReadableRepository<T> repository, String id) {
        return new ReadableRepositoryFindDsl<>(repository, id);
    }

    public static <T extends Resource> SearchableRepositoryDsl<T> stubSearch(SearchableRepository<T> repository, String query) {
        return new SearchableRepositoryDsl<>(repository, query);
    }

    public static class FakeTimelineEventsRepositoryDsl extends FakeReadableRepositoryDsl<Event> {
        private final TimelineEventsRepository repository;

        public FakeTimelineEventsRepositoryDsl(TimelineEventsRepository repository) {
            super(repository);
            this.repository = repository;
        }

        public void toReturn(Timeline timeline) {
            super.toReturn(timeline.getEvents());
            when(repository.timelineId()).thenReturn(timeline.getId());
        }
    }

    public static FakeTimelineEventsRepositoryDsl stub(TimelineEventsRepository repository) {
        return new FakeTimelineEventsRepositoryDsl(repository);
    }
}
