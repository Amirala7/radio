import { initializeApp } from "firebase-admin/app";
import { setGlobalOptions } from "firebase-functions/v2";

initializeApp();
setGlobalOptions({ region: "europe-west1" });

export { listStations } from "./callable/listStations";
export { popularStations } from "./callable/popularStations";
export { searchStations } from "./callable/searchStations";
export { listGenres } from "./callable/listGenres";
export { stationsByGenre } from "./callable/stationsByGenre";
