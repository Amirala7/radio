import { onCall } from "firebase-functions/v2/https";
import { requireAuth } from "../lib/auth";
import { cacheKey, withCache } from "../lib/cache";
import { asObject, optionalString } from "../lib/input";
import { normalizePage } from "../lib/normalize";
import { RAPIDAPI_KEY, rapidApiGet } from "../lib/rapidapi";
import type { Page, Station } from "../lib/types";

const TTL_SECONDS = 60 * 60 * 6; // 6h

// Popular is a single-page feed — upstream returns the same payload
// regardless of page/limit, so we don't accept or forward them.
export const popularStations = onCall(
  { secrets: [RAPIDAPI_KEY] },
  async (request) => {
    requireAuth(request);
    const d = asObject(request.data);
    const country = optionalString(d.country, "country");

    const path = country
      ? `/radios/popular/${encodeURIComponent(country)}`
      : "/radios/popular";

    const key = cacheKey("popularStations", { country });
    return withCache<Page<Station>>(key, TTL_SECONDS, async () => {
      const raw = await rapidApiGet(path, {});
      return normalizePage(raw, 1, 0);
    });
  },
);
