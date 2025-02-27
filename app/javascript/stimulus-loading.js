import { application } from "./controllers/application";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";


export function eagerLoadControllersFrom() {
    // Automatically load all controllers
const context = require.context("./controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
  }
  



