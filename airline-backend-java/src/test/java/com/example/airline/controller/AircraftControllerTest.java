package com.example.airline.controller;

import com.example.airline.dto.AircraftDTO;
import com.example.airline.model.Aircraft;
import com.example.airline.service.AircraftService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AircraftController.class)
public class AircraftControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AircraftService aircraftService;

    @Test
    public void getAllAircraft_ShouldReturnList() throws Exception {
        Aircraft aircraft = new Aircraft();
        aircraft.setAircraftCode("773");
        aircraft.setModel("Boeing 777-300");
        aircraft.setRange(11100);
        aircraft.setSeatsTotal(402);

        when(aircraftService.getAllAircraft()).thenReturn(Arrays.asList(aircraft));

        mockMvc.perform(get("/api/v1/aircraft"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].aircraftCode").value("773"))
                .andExpect(jsonPath("$[0].model").value("Boeing 777-300"));
    }

    @Test
    public void getAircraftByCode_WhenExists_ShouldReturnAircraft() throws Exception {
        Aircraft aircraft = new Aircraft();
        aircraft.setAircraftCode("773");
        aircraft.setModel("Boeing 777-300");
        aircraft.setRange(11100);
        aircraft.setSeatsTotal(402);

        when(aircraftService.getAircraftByCode("773")).thenReturn(Optional.of(aircraft));

        mockMvc.perform(get("/api/v1/aircraft/773"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.aircraftCode").value("773"));
    }
}
