const string  pluginColor = "\\$EE0";
const string  pluginIcon  = Icons::ClockO;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

void Main() {
    auto App = cast<CTrackMania>(GetApp());
    auto Network = cast<CTrackManiaNetwork>(App.Network);

    int start, end;
    string pageName;

    while (true) {
        sleep(100);

        if (false
            or Network.ClientManiaAppPlayground is null
            or App.RootMap is null
            or App.RootMap.MapInfo is null
            or App.RootMap.MapInfo.TMObjective_NbClones == 0
        ) {
            continue;
        }

        for (uint i = 0; i < Network.ClientManiaAppPlayground.UILayers.Length; i++) {
            CGameUILayer@ Layer = Network.ClientManiaAppPlayground.UILayers[i];
            if (false
                or Layer is null
                or Layer.LocalPage is null
                or Layer.Type != CGameUILayer::EUILayerType::Normal
            ) {
                continue;
            }

            start = Layer.ManialinkPageUtf8.IndexOf("<");
            end = Layer.ManialinkPageUtf8.IndexOf(">");
            if (false
                or start == -1
                or end == -1
                or end <= start + 1
            ) {
                continue;
            }

            pageName = Layer.ManialinkPageUtf8.SubStr(start + 1, end - start - 1);
            if (!pageName.Contains("UIModule_Race_Chrono")) {
                continue;
            }

            auto Frame = cast<CGameManialinkFrame>(Layer.LocalPage.GetFirstChild("frame-chrono"));
            if (true
                and Frame !is null
                and Frame.Visible != S_Enabled
            ) {
                trace((S_Enabled ? "show" : "hid") + "ing chrono");
                Frame.Visible = S_Enabled;
            }

            break;
        }
    }
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}
