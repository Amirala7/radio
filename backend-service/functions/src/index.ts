import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { setGlobalOptions } from "firebase-functions/v2";

initializeApp();
getFirestore().settings({ ignoreUndefinedProperties: true });
setGlobalOptions({ region: "europe-west1" });

export { listStations } from "./callable/listStations";
export { popularStations } from "./callable/popularStations";
export { searchStations } from "./callable/searchStations";
export { listGenres } from "./callable/listGenres";
export { stationsByGenre } from "./callable/stationsByGenre";
