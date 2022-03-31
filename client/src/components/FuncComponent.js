// import Vue from 'vue';

export default {
    name: 'funcComponent',
    render(createElement) {
        return createElement('h1', 'Hello from render function component!');
    },
}