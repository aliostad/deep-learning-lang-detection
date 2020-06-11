package application.utils;

import application.model.*;
import application.repositories.DoorRepository;
import application.repositories.HistoryEntryRepository;
import application.repositories.RoleRepository;
import application.repositories.UserRepository;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by lukasgol on 30.04.14.
 */
public class Initializer {

    RoleRepository roleRepository;
    UserRepository userRepository;
    DoorRepository doorRepository;
    HistoryEntryRepository historyEntryRepository;

    public Initializer(RoleRepository roleRepository, UserRepository useRoleRepository) {
        this.roleRepository = roleRepository;
        this.userRepository = useRoleRepository;
    }

    public Initializer(RoleRepository roleRepository,
                       UserRepository userRepository,
                       DoorRepository doorRepository,
                       HistoryEntryRepository historyEntryRepository) {
        this.roleRepository = roleRepository;
        this.userRepository = userRepository;
        this.doorRepository = doorRepository;
        this.historyEntryRepository = historyEntryRepository;
    }

    public void init(){

        User marcin = new User("Marcin", "Michalek", "m", "p");
        Set<Role> roles = new HashSet<Role>();
        roles.add(new Role("CLEANER", "shityJob"));
        roles.add(new Role("BOSS", "fuckYea"));
        marcin.setRoles(roles);
        marcin.addMessage(new Message("hello"));
        marcin.addMessage(new Message("You're fired"));
        userRepository.save(marcin);

        User lukasz = new User("Lukasz", "Golinski", "l", "p");
        Set<Role> roles2 = new HashSet<Role>();
        roles2.add(new Role("NERD", "greatJob"));
        roles2.add(new Role("BOSS", "fuckYea"));
        lukasz.setRoles(roles2);
        lukasz.addMessage(new Message("hello2"));
        lukasz.addMessage(new Message("You're fired"));
        userRepository.save(lukasz);

        DoorMessage message=new DoorMessage("Be Careful");
        doorRepository.save(new Door(message));
    }
}
