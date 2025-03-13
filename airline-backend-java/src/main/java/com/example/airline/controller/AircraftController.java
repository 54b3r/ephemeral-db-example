package com.example.airline.controller;

import com.example.airline.dto.AircraftDTO;
import com.example.airline.model.Aircraft;
import com.example.airline.service.AircraftService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/aircraft")
@RequiredArgsConstructor
public class AircraftController {
    private final AircraftService aircraftService;

    @GetMapping
    public ResponseEntity<List<AircraftDTO>> getAllAircraft() {
        List<AircraftDTO> aircraft = aircraftService.getAllAircraft()
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        return ResponseEntity.ok(aircraft);
    }

    @GetMapping("/{code}")
    public ResponseEntity<AircraftDTO> getAircraftByCode(@PathVariable String code) {
        return aircraftService.getAircraftByCode(code)
            .map(aircraft -> ResponseEntity.ok(convertToDTO(aircraft)))
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<AircraftDTO> createAircraft(@RequestBody AircraftDTO aircraftDTO) {
        Aircraft aircraft = convertToEntity(aircraftDTO);
        Aircraft savedAircraft = aircraftService.saveAircraft(aircraft);
        return ResponseEntity.ok(convertToDTO(savedAircraft));
    }

    @PutMapping("/{code}")
    public ResponseEntity<AircraftDTO> updateAircraft(
            @PathVariable String code,
            @RequestBody AircraftDTO aircraftDTO) {
        if (!code.equals(aircraftDTO.getAircraftCode())) {
            return ResponseEntity.badRequest().build();
        }
        
        Aircraft aircraft = convertToEntity(aircraftDTO);
        Aircraft updatedAircraft = aircraftService.saveAircraft(aircraft);
        return ResponseEntity.ok(convertToDTO(updatedAircraft));
    }

    @DeleteMapping("/{code}")
    public ResponseEntity<Void> deleteAircraft(@PathVariable String code) {
        aircraftService.deleteAircraft(code);
        return ResponseEntity.noContent().build();
    }

    private AircraftDTO convertToDTO(Aircraft aircraft) {
        AircraftDTO dto = new AircraftDTO();
        dto.setAircraftCode(aircraft.getAircraftCode());
        dto.setModel(aircraft.getModel());
        dto.setRange(aircraft.getRange());
        dto.setSeatsTotal(aircraft.getSeatsTotal());
        return dto;
    }

    private Aircraft convertToEntity(AircraftDTO dto) {
        Aircraft aircraft = new Aircraft();
        aircraft.setAircraftCode(dto.getAircraftCode());
        aircraft.setModel(dto.getModel());
        aircraft.setRange(dto.getRange());
        aircraft.setSeatsTotal(dto.getSeatsTotal());
        return aircraft;
    }
}
