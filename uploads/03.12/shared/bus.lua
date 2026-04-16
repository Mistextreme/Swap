-- ============================================================================
-- Bus Stop Definitions
-- Physical bus stop locations organized by route group.
-- These define where bus stops exist on the map and are used for:
--   1. Map display in Dashboard & Dispatch NUI
--   2. NPC settings (minNPC, maxNPC, zone) for stops referenced by loop routes
-- Routes in Config.Routes reference these stops by using their coordinates.
-- ============================================================================

BusStops = {}

BusStops.Routes = {
    [1] = {
        id = 1,
        name = 'Downtown Loop',
        description = 'A basic route circling downtown key locations',
        color = '#4CAF50',
        stops = {
            { id = 1,  name = 'Bus Stop #1',  coords = vector4(119.53, -785.99, 31.27, 69.83),    zone = 1 },
            { id = 2,  name = 'Bus Stop #2',  coords = vector4(-243.87, -710.24, 33.44, 158.95),   zone = 1 },
            { id = 3,  name = 'Bus Stop #3',  coords = vector4(308.71, -762.10, 29.24, 160.92),    zone = 1 },
            { id = 4,  name = 'Bus Stop #4',  coords = vector4(352.11, -1064.15, 29.40, 269.74),   zone = 1 },
            { id = 5,  name = 'Bus Stop #5',  coords = vector4(262.23, -1124.56, 29.21, 88.91),    zone = 1 },
            { id = 6,  name = 'Bus Stop #6',  coords = vector4(50.05, -1537.32, 29.19, 319.73),    zone = 1 },
            { id = 7,  name = 'Bus Stop #7',  coords = vector4(359.04, -1785.44, 28.92, 319.46),   zone = 1 },
            { id = 8,  name = 'Bus Stop #8',  coords = vector4(-690.06, -5.56, 38.18, 107.37),     zone = 2 },
            { id = 9,  name = 'Bus Stop #9',  coords = vector4(-930.80, -126.50, 37.57, 117.20),   zone = 2 },
            { id = 10, name = 'Bus Stop #10', coords = vector4(-1165.57, -400.93, 35.49, 98.45),   zone = 2 },
            { id = 11, name = 'Bus Stop #11', coords = vector4(-1426.65, -89.70, 52.06, 296.41),   zone = 2 },
            { id = 12, name = 'Bus Stop #12', coords = vector4(-520.12, -265.83, 35.33, 112.43),   zone = 2 },
            { id = 13, name = 'Bus Stop #13', coords = vector4(-643.60, -143.64, 37.70, 30.40),    zone = 2 },
            { id = 14, name = 'Bus Stop #14', coords = vector4(-684.00, -374.94, 34.19, 249.64),   zone = 2 },
            { id = 15, name = 'Bus Stop #15', coords = vector4(-563.67, -846.34, 27.04, 269.80),   zone = 3 },
            { id = 16, name = 'Bus Stop #16', coords = vector4(-1171.51, -1466.63, 4.28, 214.05),  zone = 3 },
            { id = 17, name = 'Bus Stop #17', coords = vector4(-1213.40, -1213.86, 7.59, 191.47),  zone = 3 },
            { id = 18, name = 'Bus Stop #18', coords = vector4(-153.77, 6209.21, 31.19, 319.90),   zone = 3 },
            { id = 19, name = 'Bus Stop #19', coords = vector4(-212.45, 6175.96, 31.22, 134.68),   zone = 3 },
        },
    },
    [2] = {
        id = 2,
        name = 'Airport Shuttle',
        description = 'Connects LS International Airport to downtown',
        color = '#2196F3',
        stops = {
            { id = 1,  name = 'Bus Stop #1',  coords = vector4(-272.29, -826.78, 31.70, 340.63),   zone = 1 },
            { id = 2,  name = 'Bus Stop #2',  coords = vector4(-253.09, -882.32, 30.66, 251.86),   zone = 1 },
            { id = 3,  name = 'Bus Stop #3',  coords = vector4(-171.30, -815.88, 31.17, 159.84),   zone = 1 },
            { id = 4,  name = 'Bus Stop #4',  coords = vector4(-499.96, 20.90, 44.76, 93.28),      zone = 1 },
            { id = 5,  name = 'Bus Stop #5',  coords = vector4(-145.97, -2039.49, 22.93, 255.91),  zone = 1 },
            { id = 6,  name = 'Bus Stop #6',  coords = vector4(-147.85, -2045.19, 22.95, 254.27),  zone = 2 },
            { id = 7,  name = 'Bus Stop #7',  coords = vector4(-139.94, -1969.90, 22.79, 272.54),  zone = 2 },
            { id = 8,  name = 'Bus Stop #8',  coords = vector4(-139.66, -1975.67, 22.81, 272.59),  zone = 2 },
            { id = 9,  name = 'Bus Stop #9',  coords = vector4(-139.28, -1981.69, 22.83, 272.50),  zone = 2 },
            { id = 10, name = 'Bus Stop #10', coords = vector4(-138.77, -1987.88, 22.83, 272.61),  zone = 2 },
            { id = 11, name = 'Bus Stop #11', coords = vector4(-144.53, -2033.07, 22.92, 254.33),  zone = 3 },
            { id = 12, name = 'Bus Stop #12', coords = vector4(-142.39, -2028.18, 22.93, 254.99),  zone = 3 },
            { id = 13, name = 'Bus Stop #13', coords = vector4(-1406.51, -567.28, 30.22, 118.25),  zone = 3 },
            { id = 14, name = 'Bus Stop #14', coords = vector4(-1522.72, -464.74, 35.30, 121.98),  zone = 3 },
            { id = 15, name = 'Bus Stop #15', coords = vector4(-1480.71, -634.76, 30.36, 305.94),  zone = 3 },
        },
    },
    [3] = {
        id = 3,
        name = 'Outer Loop',
        description = 'Long-distance route connecting Sandy Shores and Paleto Bay',
        color = '#FF9800',
        stops = {
            { id = 1,  name = 'Bus Stop #1',  coords = vector4(768.75, -1751.52, 29.38, 264.35),   zone = 1 },
            { id = 2,  name = 'Bus Stop #2',  coords = vector4(825.64, -1634.54, 30.53, 174.61),   zone = 1 },
            { id = 3,  name = 'Bus Stop #3',  coords = vector4(936.89, -1752.65, 31.05, 85.80),    zone = 1 },
            { id = 4,  name = 'Bus Stop #4',  coords = vector4(874.59, -1766.67, 29.76, 265.44),   zone = 1 },
            { id = 5,  name = 'Bus Stop #5',  coords = vector4(788.24, -1364.99, 26.44, 179.60),   zone = 1 },
            { id = 6,  name = 'Bus Stop #6',  coords = vector4(807.31, -1357.20, 26.31, 359.71),   zone = 2 },
            { id = 7,  name = 'Bus Stop #7',  coords = vector4(770.13, -935.98, 25.54, 185.55),    zone = 2 },
            { id = 8,  name = 'Bus Stop #8',  coords = vector4(785.38, -781.06, 26.33, 0.19),      zone = 2 },
            { id = 9,  name = 'Bus Stop #9',  coords = vector4(-105.45, -1684.01, 29.20, 139.92),  zone = 2 },
            { id = 10, name = 'Bus Stop #10', coords = vector4(436.96, -2027.34, 23.31, 225.44),   zone = 2 },
            { id = 11, name = 'Bus Stop #11', coords = vector4(-708.19, -827.38, 23.45, 90.43),    zone = 3 },
            { id = 12, name = 'Bus Stop #12', coords = vector4(-740.44, -755.26, 26.46, 0.40),     zone = 3 },
            { id = 13, name = 'Bus Stop #13', coords = vector4(-696.64, -667.89, 30.70, 269.11),   zone = 3 },
            { id = 14, name = 'Bus Stop #14', coords = vector4(-510.08, -668.18, 33.04, 270.26),   zone = 3 },
        },
    },
}
