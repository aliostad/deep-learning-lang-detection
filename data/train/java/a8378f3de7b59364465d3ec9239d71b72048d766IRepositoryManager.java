package org.d2j.game;

import org.d2j.game.repository.*;

import java.sql.SQLException;

/**
 * User: Blackrush
 * Date: 27/12/11
 * Time: 15:48
 * IDE : IntelliJ IDEA
 */
public interface IRepositoryManager {
    void start();
    void stop();
    void save() throws SQLException;

    AccountRepository getAccounts();
    CharacterRepository getCharacters();
    ItemRepository getItems();
    SpellRepository getSpells();
    FriendRepository getFriends();
    NpcRepository getNpcs();
    GuildRepository getGuilds();
    GuildMemberRepository getGuildMembers();

    BreedTemplateRepository getBreedTemplates();
    ExperienceTemplateRepository getExperienceTemplates();
    MapRepository getMaps();
    MapTriggerRepository getMapTriggers();
    SpellTemplateRepository getSpellTemplates();
    SpellBreedRepository getSpellBreeds();
    ItemTemplateRepository getItemTemplates();
    ItemSetTemplateRepository getItemSetTemplates();
    NpcTemplateRepository getNpcTemplates();
    NpcQuestionRepository getNpcQuestions();
    NpcResponseRepository getNpcResponses();
    NpcSellRepository getNpcSells();
    WaypointRepository getWaypoints();
    MarketPlaceRepository getMarketPlaces();
}
