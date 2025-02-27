// app/javascript/controllers/index.js
import { application } from "./application";
import { eagerLoadControllersFrom } from "../stimulus-loading";

eagerLoadControllersFrom("controllers", application);
