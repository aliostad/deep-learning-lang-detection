package com.lastminute.bootcamp16.antani.adapters;

import com.lastminute.bootcamp16.antani.domain.ports.ParticipantsRepository;
import org.junit.Test;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class InMemoryParticipantsRepositoryTest {

  @Test
  public void noParticipants() {
    ParticipantsRepository repository = new InMemoryParticipantsRepository();
    assertThat(repository.countParticipants("01"), is(0));
  }

  @Test
  public void oneParticipant() {
    ParticipantsRepository repository = new InMemoryParticipantsRepository();
    repository.register("01");
    assertThat(repository.countParticipants("01"), is(1));
  }

  @Test
  public void differentCoursesParticipants() {
    ParticipantsRepository repository = new InMemoryParticipantsRepository();
    repository.register("01");
    repository.register("01");
    repository.register("02");
    assertThat(repository.countParticipants("01"), is(2));
    assertThat(repository.countParticipants("02"), is(1));
  }


  @Test
  public void onePartecipantWithEmail() {
    ParticipantsRepository repository = new InMemoryParticipantsRepository();
    repository.registerMail("01", "email@email.it");
    assertThat(repository.countParticipants("01"), is(1));
  }

}
