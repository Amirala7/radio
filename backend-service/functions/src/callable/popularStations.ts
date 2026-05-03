import { onCall } from "firebase-functions/v2/https";
import { requireAuth } from "../lib/auth";
import { cacheKey, withCache } from "../lib/cache";
import { asObject, optionalInt, optionalString } from "../lib/input";
import { normalizePage } from "../lib/normalize";
import { RAPIDAPI_KEY, rapidApiGet } from "../lib/rapidapi";
import type { Page, Station } from "../lib/types";

const TTL_SECONDS = 60 * 60 * 6; // 6h

export const popularStations = onCall(
  { secrets: [RAPIDAPI_KEY] },
  async (request) => {
    requireAuth(request);
    const d = asObject(request.data);
    const country = optionalString(d.country, "country");
    const page = optionalInt(d.page, "page", 1, 1000) ?? 1;
    const limit = optionalInt(d.limit, "limit", 1, 100) ?? 20;

    const path = country
      ? `/radios/popular/${encodeURIComponent(country)}`
      : "/radios/popular";

    const key = cacheKey("popularStations", { country, page, limit });
    return withCache<Page<Station>>(key, TTL_SECONDS, async () => {
      const raw = await rapidApiGet(path, { page, limit });
      return normalizePage(raw, page, limit);
    });
  },
);
