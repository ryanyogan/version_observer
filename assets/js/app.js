import { Elm } from "../src/Main.elm";
import socket from "./socket";
import "../css/app.css";
import "phoenix_html";

const { appVersion } = window;

const app = Elm.Main.init({ flags: { appVersion } });

const channel = socket.channel("version", {});

channel.join().receive("ok", () => {
  channel.on("new_version", ({ newVersion }) => {
    app.ports.newVersion.send(newVersion);
  });
});
