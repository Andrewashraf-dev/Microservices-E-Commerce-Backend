package com.example.orderservice.Order;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
    
@RestController
@RequestMapping("/api/order")
@RequiredArgsConstructor
public class OrderController {

    private final WebClient webClient;

    @PostMapping
    public String placeOrder(@RequestParam String productCode) {
        // PRO STEP: Call Inventory service using Service-to-Service Token
        Boolean isInStock = webClient.get() 
        // restclient prefer
                .uri("http://inventory-service:8082/api/inventory?code=" + productCode)
                .retrieve()
                .bodyToMono(Boolean.class)
                .block();

        if (isInStock) {
            return "Order placed successfully!";
        } else {
            return "Product out of stock.";
        }
    }
}