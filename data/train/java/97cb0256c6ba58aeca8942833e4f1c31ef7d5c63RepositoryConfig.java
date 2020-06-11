package com.hotel.reservation.config;

import com.hotel.reservation.reservation.repository.ReservationRepository;
import com.hotel.reservation.reservation.repository.ReservationRepositoryImpl;
import com.hotel.reservation.room.repository.RoomRepository;
import com.hotel.reservation.room.repository.RoomRepositoryImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * Project: Hotel-Reservation
 * Package Name: com.hotel.reservation.config
 * Created by: krganeshrajhan
 * Description:
 */
@Configuration
@Import(DbConfig.class)
public class RepositoryConfig {

    @Bean
    public RoomRepository roomRepository() {

        return new RoomRepositoryImpl();
    }

    @Bean
    public ReservationRepository reservationRepository() {

        ReservationRepositoryImpl reservationrepository = new ReservationRepositoryImpl();
        reservationrepository.setRoomRepository(roomRepository());
        return reservationrepository;
    }

}
