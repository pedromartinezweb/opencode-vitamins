# Task: Ambulance SaaS POC

Build a complete POC for an ambulance transport SaaS.

## Goal

Create a beautiful Apple-inspired web app for a private ambulance company. The POC must run with one `docker-compose.yml` and include:

- Frontend.
- Java 23 Spring Boot backend.
- PostgreSQL database.

The system manages ambulances, drivers, patients, hospitals, daily appointments, route optimization, ambulance timelines, and driver route panels.

## Product Context

The company transports patients from home to hospitals and back after appointments. Dispatchers need a daily planning tool that groups compatible patients by hospital, appointment time, ambulance capacity, and route feasibility. Drivers need a simple mobile-friendly panel showing their assigned ambulance, stops, times, and Google Maps navigation links.

The product is a SaaS-style operational dashboard, not a marketing website.

## UI Direction

Create a polished Apple.com-inspired SaaS UI:

- Clean light surfaces.
- Premium spacing and typography.
- Strong visual hierarchy.
- Subtle borders, depth, and motion.
- Calm dashboard density.
- Responsive desktop and mobile layouts.
- First screen must be the usable app dashboard.

Do not copy Apple logos, text, assets, or exact layouts. Use only a similar premium, minimal, clean interaction style.

## Main Personas

- Dispatcher: manages master data, generates daily schedules, reviews ambulance timelines.
- Driver: sees assigned route, stops, patient pickups/dropoffs, and opens navigation in Google Maps.
- Admin: seeds and configures POC data.

## Core Modules

- Dashboard.
- Ambulance management.
- Driver management.
- Patient request management.
- Hospital management.
- Daily route optimization.
- Ambulance timeline.
- Driver route panel.

## Domain Model

Implement a pragmatic POC model. Use simple relational tables and clean backend entities.

### Ambulance

- id.
- code.
- name.
- capacity.
- baseAddress.
- active.
- capabilities.

### Driver

- id.
- name.
- phone.
- licenseNumber.
- active.
- ambulanceId.

Each active driver is assigned to one ambulance for the POC.

### Hospital

- id.
- name.
- address.
- latitude.
- longitude.

Coordinates are optional in forms but useful for seed data.

### Patient

- id.
- fullName.
- phone.
- homeAddress.
- latitude.
- longitude.
- specialNeeds.
- companionRequired.

### TransportRequest

- id.
- patientId.
- hospitalId.
- appointmentAt.
- needsReturnTrip.
- consultationDurationMinutes.
- pickupFlexibilityMinutesBefore.
- maxDetourMinutes.
- status.

### RoutePlan

- id.
- planDate.
- generatedAt.
- status.

### RouteAssignment

- id.
- routePlanId.
- ambulanceId.
- driverId.
- totalDurationMinutes.
- totalDistanceMeters.
- assignedPatientsCount.

### RouteStop

- id.
- assignmentId.
- sequence.
- stopType: START, PICKUP, DROPOFF, END.
- patientId.
- hospitalId.
- address.
- estimatedArrivalAt.
- estimatedDepartureAt.
- targetTime.
- returnTrip.
- googleMapsUrl.

## API Scope

Expose REST APIs under `/api`.

Minimum endpoints:

- `GET /api/health`.
- CRUD `/api/ambulances`.
- CRUD `/api/drivers`.
- CRUD `/api/hospitals`.
- CRUD `/api/patients`.
- CRUD `/api/transport-requests`.
- `POST /api/route-plans/generate?date=YYYY-MM-DD`.
- `GET /api/route-plans`.
- `GET /api/route-plans/{id}`.
- `GET /api/drivers/{id}/routes?date=YYYY-MM-DD`.

Optional compatibility endpoints inspired by the previous backend:

- `POST /api/distance`.
- `POST /api/route-matrix`.
- `POST /api/routes/optimize`.
- `GET /api/routes/{batchId}`.

## Scheduling Rules

Create a deterministic POC scheduling algorithm. Keep it testable without external APIs.

Rules:

- Schedule by day.
- Use only active ambulances and active drivers.
- Each route assignment has one driver and one ambulance.
- Group requests by hospital first.
- Inside each hospital group, order by appointment time.
- Prefer grouping patients with close appointment times.
- Respect ambulance capacity.
- Add outbound trip stops:
  - START at ambulance base.
  - PICKUP patient at home.
  - DROPOFF patient at hospital.
- Add return trip stops when `needsReturnTrip` is true:
  - PICKUP patient at hospital after consultation duration.
  - DROPOFF patient at home.
- Add END at ambulance base.
- Use deterministic estimated travel duration:
  - Prefer coordinate-based approximation when coordinates exist.
  - Otherwise use fixed defaults by stop type.
- Include stop service time, default 5 minutes.
- Ensure patients arrive before appointment time when possible.
- Mark impossible requests as unassigned or keep status visible.

The first version does not need a full VRP solver. Implement a clear insertion/grouping heuristic and cover it with tests.

## Optimization Inspiration

The algorithm may evolve later toward an adapted insertion heuristic for vehicle routing with time windows:

1. Start empty routes per ambulance.
2. Sort transport requests by appointment time.
3. Evaluate feasible insertions by hospital, time window, capacity, and detour.
4. Pick the lowest-cost insertion.
5. Mark impossible requests as unassigned.
6. Post-process route timelines.

For the POC, implement the simplest deterministic subset that demonstrates value and is easy to explain.

## Google Maps

Do not require a Google Maps API key for the POC to work.

Implement Google Maps integration as generated URLs:

- Stop-to-stop navigation.
- Full assignment route with origin, destination, and waypoints when feasible.

If a `GOOGLE_MAPS_API_KEY` exists, the backend may optionally expose configuration for future geocoding/distance integration, but tests must not depend on Google APIs.

## Architecture

Backend must use clean layers:

- controller.
- application/service.
- domain/model.
- persistence/repository.
- configuration.

Keep scheduling logic isolated in a testable service.

Frontend must use clean structure:

- API client.
- pages.
- components.
- domain types.
- state/hooks.

Avoid broad abstractions. Use simple code with short descriptive names.

## Technical Requirements

- One root `docker-compose.yml`.
- Backend: Java 23, Spring Boot.
- Database: PostgreSQL.
- Frontend: choose a modern stack, preferably React + TypeScript + Vite unless there is a better reason.
- Database migrations or startup schema.
- Seed data for a realistic demo in Madrid.
- Backend tests for scheduling logic.
- Frontend build check and useful tests when feasible.
- README with exact commands.

## Seed Data

Include demo data:

- 3 hospitals in Madrid.
- 5 ambulances with capacities.
- 5 drivers assigned to ambulances.
- 12 patients with addresses.
- 12 transport requests across the same day.
- Mix of return trips, companions, wheelchair needs, and appointment times.

## Driver Panel

Create a driver-facing view:

- Select or open a driver.
- Show assigned ambulance.
- Show today's route timeline.
- Show each stop with time, type, patient, address, and status.
- Button/link to open Google Maps for the stop or route.
- Mobile-friendly layout.

## Dispatcher View

Create dispatcher views:

- Dashboard with active ambulances, pending requests, generated routes, unassigned requests.
- CRUD screens or inline forms for ambulances, drivers, hospitals, patients, and requests.
- Route plan generation by date.
- Timeline grouped by ambulance.
- Clear unassigned requests panel.

## Security For POC

No full auth is required unless simple to add, but:

- Do not hardcode secrets.
- Use environment variables for database and optional Google Maps key.
- Validate input server-side.
- Keep patient data minimal in seed data.
- Avoid exposing stack traces in API responses.

## Expected Deliverable

The repository should contain:

- `docker-compose.yml`.
- Backend source.
- Frontend source.
- Database schema/migrations.
- Seed data.
- Tests.
- README.
- Updated task board with plan, status, commands run, and final result.

## Acceptance Criteria

- `docker compose up --build` starts database, backend, and frontend.
- Frontend is reachable locally.
- Backend health endpoint works.
- Demo data appears in the UI.
- User can create ambulances, drivers, hospitals, patients, and transport requests.
- User can generate a route plan for a day.
- Route generation groups compatible patients by hospital and appointment time.
- Ambulance timelines show outbound and return trips.
- Driver panel shows assigned route and Google Maps links.
- Scheduling logic has automated tests.
- README documents setup, URLs, commands, and limitations.
- Final verification reports passing commands or clear blockers.
