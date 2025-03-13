package com.example.airline.service;

import com.example.airline.model.Aircraft;
import com.example.airline.repository.AircraftRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AircraftService {
    private final AircraftRepository aircraftRepository;

    public List<Aircraft> getAllAircraft() {
        return aircraftRepository.findAll();
    }

    public Optional<Aircraft> getAircraftByCode(String code) {
        return aircraftRepository.findById(code);
    }

    @Transactional
    public Aircraft saveAircraft(Aircraft aircraft) {
        return aircraftRepository.save(aircraft);
    }

    @Transactional
    public void deleteAircraft(String code) {
        aircraftRepository.deleteById(code);
    }
}
