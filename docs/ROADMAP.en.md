# 🧭 Qeyafa Project Roadmap 3.0 (Agile Roadmap)

**Vision:** To build the market-leading smart tailoring platform by offering an unparalleled, AI-driven customization experience while fostering a trusted community of designers and customers.

---

### I. Competitive Edge Features

These strategic features are integrated directly into the technical roadmap to ensure their implementation:

1.  **Dual Reputation System:** The customer rates the designer after receiving the order, and the designer rates the experience of working with the customer.
2.  **"Qeyafa Certified Designer" Badge:** A badge displayed on the designer's profile to increase trust, granted by the admin based on quality criteria.
3.  **Interactive Measurement Guide:** An animated visual guide within the app to help customers take their measurements with high accuracy.
4.  **"Qeyafa Points" (Loyalty Program):** A loyalty points system that rewards customers for their purchases and engagement, which can be redeemed for discounts or exclusive features.

---

### II. Technical Execution Plan

#### **Phase 1: Advanced Foundations**

| Sprint | Key Objectives | Technical Deliverables |
| :--- | :--- | :--- |
| **1. Competitive Data Models** | Build data structures that support the platform's full vision. | 1. **Reputation Models:** Add rating and review fields (`rating`, `review`) to the `Order` model.<br>2. **Designer Models:** Add an `is_certified` field to the `Designer` model.<br>3. **Loyalty Models:** Create a `LoyaltyPoints` model linked to the customer.<br>4. **Design & Pricing Models:** Build `Fabric`, `Color`, `CustomizationOption`, and `PricingRule` models. |
| **2. Web Portals** | Build the foundation for the Designer and Admin dashboards. | 1. **Designer Portal:** Build APIs for managing designs, available fabrics, and customization options.<br>2. **Admin Portal:** Build APIs for managing users, granting certifications, and monitoring orders.<br>3. Build the basic front-end for both web portals. |
| **3. Smart Sizing System** | Create a flexible sizing module that can be invoked at any time. | 1. Build APIs to save and update customer measurements.<br>2. **(Mobile App):** Develop the **Interactive Measurement Guide** as a separate screen.<br>3. **(AI Backend):** Prepare the backend to receive customer images for future analysis (`POST /measurements/upload`). |

#### **Phase 2: The Ready-Made Design Journey**

| Sprint | Key Objectives | Technical Deliverables |
| :--- | :--- | :--- |
| **4. Design Gallery & Customization** | Enable customers to browse and customize ready-made designs. | 1. **(Backend):** Build APIs to display designs with customization options available for each designer.<br>2. **(Mobile App):** Build the design gallery and detail page screens.<br>3. **(Live Pricing):** Implement live pricing logic that updates the price instantly when fabric, color, or any other option is changed. |
| **5. Flexible Sizing Journey** | Allow the customer to enter their measurements before or after selecting a design. | 1. **(Mobile App):** Add an "Add Your Measurements" button in the design gallery (before selection) and on the design customization page (after selection).<br>2. Ensure the system handles both cases seamlessly. |
| **6. Virtual Try-On & Checkout** | Preview the design and complete the purchase process. | 1. Build a `VirtualTryOn` service that merges the customized design with the customer's measurements.<br>2. Build the shopping cart and order system logic (`Order`, `Cart`).<br>3. **(Backend):** Build a notification system to send the order to the designer and a **loyalty system** to award points after order completion. |

#### **Phase 3: The Full Customization Journey**

| Sprint | Key Objectives | Technical Deliverables |
| :--- | :--- | :--- |
| **7. Mandatory Sizing Gate** | **Force the customer to enter measurements first** to begin the free-form design journey. | 1. **(Mobile App):** Design a mandatory flow starting with a "Start Your Design" screen that immediately takes the user to the **Sizing Module**. Progression is blocked without this step. |
| **8. AI Stylist** | Assist the customer in designing their garment from scratch via an interactive interface. | 1. **(Backend):** Build a chat API (`POST /ai-stylist/chat`) connected to an AI service.<br>2. **(Mobile App):** Build the chat interface that suggests options (fabrics, cuts, colors) and allows the user to add their own touches (embroidery, logo printing).<br>3. **(Live Pricing):** Connect every suggestion from the AI Stylist to the live pricing engine. |
| **9. Final Output for Designer** | Provide the designer with a precise technical file for the order. | 1. **(Backend):** Build a service to dynamically generate a PDF file containing all custom design details and exact measurements.<br>2. **(Designer Portal & App):** Add a "Download Technical Design" option on the order page. |