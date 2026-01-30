package com.example.inventoryservice.Inventory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    @GetMapping
    public boolean isInStock(@RequestParam String code) {
        // In a real app, you would check your DB here
        return "laptop".equalsIgnoreCase(code); 
    }
}